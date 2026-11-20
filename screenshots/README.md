# Captures d'écran

Ce dossier est réservé aux captures réelles de l'application. Aucune image
de démonstration ou maquette n'est fournie.

Après avoir lancé l'application sur un émulateur ou un appareil Android,
enregistrez les captures sous les noms suivants, puis les images apparaîtront
dans la section correspondante du README :

- `login.png` : écran de connexion, avant authentification.
- `home.png` : onglet Accueil.
- `family.png` : onglet Famille.
- `contact.png` : onglet Contact.

Exemple avec Android Debug Bridge, avec l'application ouverte sur l'écran
souhaité, puis récupérez la capture avec Android Debug Bridge :
`adb shell screencap -p /sdcard/login.png` puis
`adb pull /sdcard/login.png screenshots\login.png`.
