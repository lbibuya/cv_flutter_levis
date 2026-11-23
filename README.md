# CV Flutter Levis — TP1 et TP2

Application Flutter de présentation du CV, de la famille et des coordonnées de
Levis BIBUYA TSIBIRA. Ce dépôt présente d'abord le travail réalisé au TP1,
puis son évolution au TP2 avec une API Flask, PostgreSQL sur Supabase et une
authentification JWT.

## TP1 — Application Flutter initiale

Le TP1 est une application Flutter qui présente le profil et le parcours de
Levis. Elle comprend :

- une page de connexion;
- une page d'accueil;
- une page CV avec photo, formation, expériences et compétences;
- une page Famille avec les membres, leurs photos et leurs liens;
- une page Contact;
- une navigation entre les pages avec la barre de navigation.

L'application a été exécutée dans Chrome avec `flutter run -d chrome`.
Les captures d'écran du TP1 :

| Écran | Capture |
|---|---|
| Connexion | <img width="630" height="987" alt="Connexion TP1" src="https://github.com/user-attachments/assets/b8b9cdcf-a6bb-4595-8eb2-f8b1150ec250" /> |
| Accueil | <img width="630" height="991" alt="Accueil TP1" src="https://github.com/user-attachments/assets/93252845-6862-4c55-bbfa-ef73b16cdc70" /> |
| Famille | <img width="631" height="1020" alt="Famille TP1" src="https://github.com/user-attachments/assets/3b1a6054-6059-4c54-a5d1-30d6e79d7f53" /> |
| Contact | <img width="627" height="1021" alt="Contact TP1" src="https://github.com/user-attachments/assets/afee0c3f-fffb-431e-a4e5-718298fa604f" /> |

## TP2 — API REST, base de données et authentification

Au TP2, la connexion est vérifiée par le serveur. Les membres de la famille
sont lus et modifiés via l'API Flask et enregistrés dans PostgreSQL sur
Supabase.

### Architecture et fichiers

- **Frontend** : Flutter/Dart, `http` et `shared_preferences` pour conserver le
  JWT.
- **Backend** : Flask, Flask-CORS, psycopg2, bcrypt et PyJWT. Les jetons JWT
  expirent après 24 heures.
- **Base de données** : PostgreSQL hébergé sur Supabase. Le schéma et les
  données initiales de la famille sont dans un script SQL indépendant.

## Vidéo de démonstration

La prévisualisation intégrée des fichiers vidéo n'est pas prise en charge dans
ce README GitHub. Utilise le lien ci-dessous pour ouvrir ou télécharger la
vidéo  du demonstation et la regarde :

[Ouvrir ou télécharger la vidéo de démonstration TP2](https://raw.githubusercontent.com/lbibuya/cv_flutter_levis/main/assets/video/demonstration.webm)
