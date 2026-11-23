import getpass

import bcrypt
import psycopg2
from psycopg2 import errors

from config import DATABASE_URL


def main():
    email = input("Email du compte [lbibuya@gmail.com] : ").strip().lower()
    email = email or "lbibuya@gmail.com"
    if "@" not in email:
        raise SystemExit("Adresse email invalide.")

    password = getpass.getpass("Mot de passe (non affiché) : ")
    confirmation = getpass.getpass("Confirmez le mot de passe : ")
    if not password or password != confirmation:
        raise SystemExit("Le mot de passe est vide ou les saisies diffèrent.")

    password_hash = bcrypt.hashpw(
        password.encode("utf-8"), bcrypt.gensalt(rounds=12)
    ).decode("utf-8")
    try:
        with psycopg2.connect(
            DATABASE_URL, sslmode="require", connect_timeout=10
        ) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO public.users (email, password_hash) "
                    "VALUES (%s, %s)",
                    (email, password_hash),
                )
    except errors.UniqueViolation as error:
        raise SystemExit("Un compte existe déjà pour cet email.") from error

    print(f"Compte créé pour {email}.")


if __name__ == "__main__":
    main()
