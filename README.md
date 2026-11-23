# cv_flutter_levis — TP2

Application Flutter de présentation du CV et de la famille de Levis BIBUYA
TSIBIRA. L'authentification est vérifiée par une API REST Flask, qui stocke
les comptes et les membres de la famille dans PostgreSQL sur Supabase.

## Architecture

- **Flutter / Dart** : interface, navigation, formulaire de connexion et appels
  HTTP avec `http`. Le jeton JWT est conservé dans `shared_preferences`.
- **Flask** : authentification par bcrypt, émission de JWT valables 24 heures,
  et API de gestion familiale protégée par Bearer token.
- **PostgreSQL / Supabase** : tables `users` et `famille`; le script SQL insère
  les personnes déjà affichées dans la version TP1.

## Structure

```text
cv_flutter_levis/
├── lib/
│   ├── main.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── app_api.dart
│   │   └── http_app_api.dart
│   ├── pages/                 # Points d'entrée des pages de l'application
│   │   ├── login_page.dart
│   │   ├── famille_page.dart
│   │   ├── cv_page.dart
│   │   ├── contact_page.dart
│   │   └── main_navigation.dart
│   ├── screens/                # Implémentation complète des écrans Flutter
│   ├── models/
│   ├── theme/
│   └── widgets/
├── backend/
│   ├── app.py
│   ├── config.py
│   ├── create_user.py
│   ├── requirements.txt
│   └── .env.example
├── database/
│   └── schema.sql
├── assets/
├── pubspec.yaml
└── README.md
```

Les dossiers Flutter `screens/`, `models/`, `theme/` et `widgets/` conservent
les composants déjà construits au TP1. Les fichiers `lib/pages/` exposent les
pages demandées, sans dupliquer l'interface existante.

## Endpoints REST

Toutes les routes commencent par `http://127.0.0.1:5000/api`.

| Méthode | Route | Authentification | Description |
|---|---|---|---|
| `POST` | `/auth/login` | Non | Reçoit `email` et `password`; renvoie un JWT et l'utilisateur, ou `401`. |
| `GET` | `/famille` | Bearer JWT | Renvoie les membres de la famille. |
| `POST` | `/famille` | Bearer JWT | Ajoute `{nom, lien, profession, photo_url}`. |
| `PUT` | `/famille/<id>` | Bearer JWT | Modifie les champs transmis. |
| `DELETE` | `/famille/<id>` | Bearer JWT | Supprime le membre (`204`). |
| `GET` | `/health` | Non | Vérification de disponibilité de l'API. |

Un en-tête d'authentification absent renvoie `401`; un JWT invalide ou expiré
renvoie `403`. Les membres peuvent aussi contenir `description`, utilisée pour
conserver les descriptions du TP1.

les capture ont ete fait sur chrome car android studio n'as pas bien fonctionne dans mon ordinateur ,voila pourquoi je simuler l'application sur cgrome avec la commande flutter run -d chrome  puis affichez successivement l'écran de
connexion et les onglets Accueil, Famille et Contact. 


| Écran | Capture |
|---|---|
| Connexion | <img width="630" height="987" alt="Connexion" src="https://github.com/user-attachments/assets/b8b9cdcf-a6bb-4595-8eb2-f8b1150ec250" /> |
| Accueil | <img width="630" height="991" alt="Accueil" src="https://github.com/user-attachments/assets/93252845-6862-4c55-bbfa-ef73b16cdc70" /> |
| Famille | <img width="631" height="1020" alt="Famille" src="https://github.com/user-attachments/assets/3b1a6054-6059-4c54-a5d1-30d6e79d7f53" /> |
| Contact | <img width="627" height="1021" alt="Contact" src="https://github.com/user-attachments/assets/afee0c3f-fffb-431e-a4e5-718298fa604f" /> |

## Installation et lancement

### 1. Créer la base Supabase

1. Créez un projet PostgreSQL dans Supabase.
2. Ouvrez **SQL Editor**, copiez tout le contenu de
   [`database/schema.sql`](database/schema.sql), puis cliquez sur **Run**.
   Le script crée `users` et `famille` et insère les membres du TP1; les
   insertions familiales peuvent être relancées sans créer de doublons.
3. Récupérez l'URL de connexion PostgreSQL dans **Project Settings → Database**.
   Utilisez l'URL du pooler recommandée par Supabase et gardez `sslmode=require`.
   Si le mot de passe contient des caractères spéciaux, encodez-les dans l'URL.

### 2. Configurer et démarrer Flask

Dans un terminal PowerShell, depuis la racine du dépôt :

```powershell
Set-Location backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Renseignez `DATABASE_URL` et `SECRET_KEY` dans `backend/.env` (copiez d'abord
les noms de variables de `.env.example`) ou directement dans `backend/config.py`.
`config.py` contient une URL d'exemple à remplacer et une clé de développement;
choisissez une clé aléatoire privée de 32 caractères ou plus avant de lancer
l'API. Ne publiez jamais `.env`, l'URL PostgreSQL réelle ni la clé JWT.

Créez le compte de connexion et démarrez l'API :

```powershell
python create_user.py
python app.py
```

Le script demande l'e-mail (par défaut `lbibuya@gmail.com`) puis le mot de
passe deux fois sans l'afficher. Il enregistre uniquement une empreinte bcrypt
dans PostgreSQL. L'API est disponible sur `http://127.0.0.1:5000`; le contrôle
de santé répond à `http://127.0.0.1:5000/api/health`.

### 3. Démarrer Flutter sur Chrome

Dans un deuxième terminal, à la racine du projet :

```powershell
flutter pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:5000/api
```

Connectez-vous avec le compte créé par `create_user.py`. Le jeton est gardé
dans `SharedPreferences`; à la déconnexion, il est supprimé. Au démarrage, un
jeton sauvegardé restaure la session. Si l'API renvoie un statut `401` ou `403`,
la session locale est invalidée. Dans le formulaire Famille, l'ajout, la
modification et la suppression sont envoyés à Flask puis rechargés depuis l'API.

Pour un téléphone ou un émulateur, remplacez `127.0.0.1` par l'adresse réseau
de la machine qui exécute Flask. En production, utilisez HTTPS et limitez CORS
à l'origine du site au lieu de laisser l'origine ouverte comme pour ce TP local.

### 4. Vérifications

```powershell
flutter analyze
flutter test
```

Vérifiez aussi le parcours réel : mauvais mot de passe (`401`), connexion
valide, consultation de Famille, puis ajout/modification/suppression d'un
membre. Les données doivent apparaître dans Supabase. L'URL du backend de
développement n'est pas à utiliser pour une application publiée sur Internet.

## Démonstration vidéo

Lien YouTube de la démonstration : **[À remplacer par l'URL de la vidéo]**

```text
https://www.youtube.com/watch?v=REMPLACER_PAR_ID_VIDEO
```
