# cv_flutter_levis

Application mobile Flutter de présentation personnelle : parcours, compétences,
famille et coordonnées. L'interface est en français, responsive et basée sur
Material Design 3. L'authentification est locale et sert uniquement à la
démonstration ; aucune donnée n'est envoyée à un serveur.

## Objectifs

- Présenter un CV depuis une application Android moderne.
- Mettre en pratique Flutter, Dart, Material 3 et les composants réutilisables.
- Fournir un exemple facile à personnaliser et à publier sur GitHub.

## Fonctionnalités

- Écran de connexion avec validation de formulaire et affichage/masquage du mot
  de passe.
- Accès local de démonstration et message d'erreur si les identifiants sont
  incorrects.
- Quatre onglets : Accueil, Mon CV, Famille et Contact.
- CV avec profil, parcours scolaire, formations, compétences, langues et intérêts.
- Présentation responsive des membres de la famille, avec avatars de secours.
- Raccourcis téléphone et e-mail via `url_launcher`.
- Déconnexion et transitions légères.

Le CV contient les renseignements personnels fournis par Levis BIBUYA TSIBIRA.
Les photos personnelles sont dans `assets/images/`. Le dépôt public peut rendre ces renseignements
accessibles à tous : vérifiez les informations affichées avant publication.
La connexion locale ne constitue pas un mécanisme de sécurité et ne doit pas
être utilisée comme authentification réelle.

## Technologies

- Flutter et Dart
- Material Design 3
- `url_launcher`

## Prérequis

- Flutter installé et configuré dans le `PATH` (`flutter doctor` sans erreur
  bloquante).

- GitHub CLI (`gh`) pour la méthode de création du dépôt ci-dessous, ou un
  dépôt vide créé sur GitHub.

## Installation et lancement

Depuis le dossier contenant `pubspec.yaml` :

```bash
flutter pub get
flutter doctor
flutter devices
flutter run
```

Pour lancer sur un appareil précis, remplacez `<device-id>` par une valeur
affichée par `flutter devices` :

```bash
flutter run -d <device-id>
```

Identifiants de connexion :

- Identifiant : `levis`
- Mot de passe : `123456`

## Personnalisation

Les données du CV sont définies dans `lib/screens/cv_page.dart` et
`lib/screens/home_page.dart`. Les informations de la famille sont dans
`lib/models/family_member.dart`.

Les photos disponibles dans `assets/images/` sont affichées dans le portfolio :
`levis.jpg`, `papa.jpg`, `jamel.jpg`, `jovite.jpg`, `albert.jpg`,
`innocent.jpg`, `solange.jpg`, `alliance.jpg`, `desages.jpg` et
`marrianah.jpg`. Une photo de la mère n'étant pas présente, son avatar de
secours reste affiché.

## Structure du projet

```text
cv_flutter_levis/
├── android/                 # Généré par Flutter (voir note ci-dessous)
├── assets/
│   ├── icons/
│   └── images/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── family_member.dart
│   ├── screens/
│   │   ├── contact_page.dart
│   │   ├── cv_page.dart
│   │   ├── family_page.dart
│   │   ├── home_page.dart
│   │   └── login_page.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       ├── custom_card.dart
│       └── navigation_bar.dart
├── screenshots/
├── pubspec.yaml
└── README.md
```

### Plateforme Android

Si le dossier `android/` n'a pas été créé par votre installation Flutter,
générez les fichiers de plateforme Android avant le premier lancement :

```bash
flutter create --platforms=android --project-name cv_flutter_levis .
flutter pub get
flutter run
```

Cette commande complète les fichiers natifs Android du projet sans remplacer
les fichiers Dart, le README ni les ressources existantes.

## Captures d'écran réelles

les capture ont ete fait sur chrome car android studio n'as pas bien fonctionne dans mon ordinateur ,voila pourquoi je simuler l'application sur cgrome avec la commande flutter run -d chrome  puis affichez successivement l'écran de
connexion et les onglets Accueil, Famille et Contact. Enregistrez une capture
de chaque écran dans `screenshots/` sous les noms indiqués ci-dessous. 

```powershell
adb shell screencap -p /sdcard/home.png
adb pull /sdcard/home.png screenshots\home.png
```

Vous pouvez aussi utiliser le bouton de capture d'écran de l'émulateur ou les
commandes de capture natives de votre appareil.

| Écran | Capture |
|---|---|
| Connexion | ![Connexion](<img width="630" height="987" alt="formulaire" src="https://github.com/user-attachments/assets/b8b9cdcf-a6bb-4595-8eb2-f8b1150ec250" />
) |
| Accueil | ![Accueil](<img width="630" height="991" alt="acceuil" src="https://github.com/user-attachments/assets/93252845-6862-4c55-bbfa-ef73b16cdc70" />
) |
| Famille | ![Famille](<img width="631" height="1020" alt="famille" src="https://github.com/user-attachments/assets/3b1a6054-6059-4c54-a5d1-30d6e79d7f53" />
) |
| Contact | ![Contact](<img width="627" height="1021" alt="contact" src="https://github.com/user-attachments/assets/afee0c3f-fffb-431e-a4e5-718298fa604f" />
) |

Ajoutez ces quatre fichiers PNG au dépôt pour qu'ils s'affichent sur GitHub.

## Publier sur GitHub

Les commandes suivantes supposent que Git est installé, que vous êtes connecté
à GitHub CLI (`gh auth login`) et que `cv_flutter_levis` est disponible dans
votre compte. `gh repo create` crée un dépôt **public** et le connecte comme
remote `origin`.

Depuis le dossier du projet :

```bash
git init
git add .
git commit -m "Initial commit: CV Flutter Levis"
gh repo create cv_flutter_levis --public --source=. --remote=origin --push
```

Sans GitHub CLI, créez un dépôt public vide nommé `cv_flutter_levis` sur
GitHub, puis connectez-le et envoyez le code (remplacez `<votre-compte>`) :

```bash
git init
git add .
git commit -m "Initial commit: CV Flutter Levis"
git branch -M main
git remote add origin https://github.com/<votre-compte>/cv_flutter_levis.git
git push -u origin main
```
