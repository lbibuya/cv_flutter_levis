

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
