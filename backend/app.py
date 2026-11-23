from datetime import datetime, timedelta, timezone
from functools import wraps

import bcrypt
import jwt
import psycopg2
from flask import Flask, current_app, g, jsonify, request
from flask_cors import CORS
from psycopg2.extras import RealDictCursor

from config import DATABASE_URL, JWT_EXPIRATION_HOURS, SECRET_KEY

app = Flask(__name__)
app.config["SECRET_KEY"] = SECRET_KEY
CORS(app)


def _database_connection():
    return psycopg2.connect(DATABASE_URL, sslmode="require", connect_timeout=10)


def token_required(handler):
    @wraps(handler)
    def wrapped(*args, **kwargs):
        authorization = request.headers.get("Authorization", "")
        scheme, _, token = authorization.partition(" ")
        if scheme.lower() != "bearer" or not token:
            return jsonify({"message": "Token requis."}), 401
        try:
            payload = jwt.decode(token, app.config["SECRET_KEY"], algorithms=["HS256"])
            g.user_id = int(payload["sub"])
        except (jwt.InvalidTokenError, KeyError, TypeError, ValueError):
            return jsonify({"message": "Token invalide ou expiré."}), 403
        return handler(*args, **kwargs)

    return wrapped


def _json_body():
    data = request.get_json(silent=True)
    if not isinstance(data, dict):
        return None, (jsonify({"message": "Un objet JSON est requis."}), 400)
    return data, None


def _family_values(data, *, partial=False):
    fields = {
        "nom": "nom",
        "lien": "lien",
        "profession": "profession",
        "photo_url": "photo_url",
        "description": "description",
    }
    values = {}
    for field in fields:
        if field in data:
            value = data[field]
            if value is not None and not isinstance(value, str):
                return None, f"Le champ {field} doit être du texte."
            values[field] = value.strip() if value is not None else None
    if not partial:
        for field in ("nom", "lien"):
            if not values.get(field):
                return None, f"Le champ {field} est obligatoire."
        values.setdefault("profession", None)
        values.setdefault("photo_url", None)
        values.setdefault("description", "")
    elif not values:
        return None, "Au moins un champ à modifier est requis."
    elif any(not values[field] for field in ("nom", "lien") if field in values):
        return None, "Les champs nom et lien ne peuvent pas être vides."
    return values, None


@app.post("/api/auth/login")
def login():
    data, error = _json_body()
    if error:
        return error
    email = data.get("email")
    password = data.get("password")
    if not isinstance(email, str) or not isinstance(password, str):
        return jsonify({"message": "Email et mot de passe requis."}), 400

    try:
        with _database_connection() as connection:
            with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    "SELECT id, email, password_hash FROM public.users "
                    "WHERE email = %s",
                    (email.strip().lower(),),
                )
                user = cursor.fetchone()
    except psycopg2.Error:
        current_app.logger.exception("Échec de la connexion à PostgreSQL.")
        return jsonify({"message": "Service de base de données indisponible."}), 500

    password_matches = False
    if user:
        try:
            password_matches = bcrypt.checkpw(
                password.encode("utf-8"), user["password_hash"].encode("utf-8")
            )
        except (ValueError, TypeError):
            current_app.logger.error("Empreinte bcrypt invalide pour un compte.")
    if not password_matches:
        return jsonify({"message": "Identifiants incorrects."}), 401

    now = datetime.now(timezone.utc)
    token = jwt.encode(
        {
            "sub": str(user["id"]),
            "iat": now,
            "exp": now + timedelta(hours=JWT_EXPIRATION_HOURS),
        },
        app.config["SECRET_KEY"],
        algorithm="HS256",
    )
    return jsonify(
        {
            "token": token,
            "user": {"id": user["id"], "email": user["email"]},
        }
    )


@app.get("/api/famille")
@token_required
def get_famille():
    try:
        with _database_connection() as connection:
            with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    "SELECT id, nom, lien, profession, photo_url, description "
                    "FROM public.famille ORDER BY id"
                )
                members = cursor.fetchall()
    except psycopg2.Error:
        current_app.logger.exception("Impossible de charger la famille.")
        return jsonify({"message": "Impossible de charger les membres."}), 500
    return jsonify(members)


@app.post("/api/famille")
@token_required
def add_famille():
    data, error = _json_body()
    if error:
        return error
    values, validation_error = _family_values(data)
    if validation_error:
        return jsonify({"message": validation_error}), 400
    try:
        with _database_connection() as connection:
            with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    """
                    INSERT INTO public.famille
                        (nom, lien, profession, photo_url, description)
                    VALUES (%(nom)s, %(lien)s, %(profession)s, %(photo_url)s,
                            %(description)s)
                    RETURNING id, nom, lien, profession, photo_url, description
                    """,
                    values,
                )
                member = cursor.fetchone()
    except psycopg2.Error:
        current_app.logger.exception("Impossible d'ajouter un membre.")
        return jsonify({"message": "Impossible d'ajouter le membre."}), 500
    return jsonify(member), 201


@app.put("/api/famille/<int:member_id>")
@token_required
def update_famille(member_id):
    data, error = _json_body()
    if error:
        return error
    values, validation_error = _family_values(data, partial=True)
    if validation_error:
        return jsonify({"message": validation_error}), 400
    assignments = ", ".join(f"{field} = %({field})s" for field in values)
    values["id"] = member_id
    try:
        with _database_connection() as connection:
            with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    f"""
                    UPDATE public.famille SET {assignments}
                    WHERE id = %(id)s
                    RETURNING id, nom, lien, profession, photo_url, description
                    """,
                    values,
                )
                member = cursor.fetchone()
    except psycopg2.Error:
        current_app.logger.exception("Impossible de modifier le membre %s.", member_id)
        return jsonify({"message": "Impossible de modifier le membre."}), 500
    if member is None:
        return jsonify({"message": "Membre introuvable."}), 404
    return jsonify(member)


@app.delete("/api/famille/<int:member_id>")
@token_required
def delete_famille(member_id):
    try:
        with _database_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    "DELETE FROM public.famille WHERE id = %s RETURNING id",
                    (member_id,),
                )
                deleted = cursor.fetchone()
    except psycopg2.Error:
        current_app.logger.exception("Impossible de supprimer le membre %s.", member_id)
        return jsonify({"message": "Impossible de supprimer le membre."}), 500
    if deleted is None:
        return jsonify({"message": "Membre introuvable."}), 404
    return "", 204


@app.get("/api/health")
def health():
    return jsonify({"status": "ok"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
