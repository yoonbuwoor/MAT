# Générer l’AAB signé pour Google Play

Le workflow `.github/workflows/main.yml` construit désormais un **Android App
Bundle signé** nommé `Moi_Geomaticien_PlayStore.aab`. Il est prêt pour Google
Play lorsque la clé d’upload a été configurée une seule fois dans GitHub.

## 1. Créer la clé d’upload sur Windows

Ouvre PowerShell dans un dossier sûr puis exécute :

```powershell
keytool -genkeypair -v -keystore upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Conserve le fichier `upload-keystore.jks`, l’alias et les deux mots de passe
dans un emplacement sauvegardé. Cette même clé doit être réutilisée pour les
mises à jour de l’application.

Transforme ensuite la clé en texte Base64 et copie le résultat :

```powershell
$bytes = [System.IO.File]::ReadAllBytes("upload-keystore.jks")
[Convert]::ToBase64String($bytes) | Set-Clipboard
```

## 2. Ajouter les quatre secrets GitHub

Dans le dépôt : **Settings → Secrets and variables → Actions → New repository
secret**. Crée exactement :

| Secret | Valeur |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | Le long texte Base64 copié dans PowerShell |
| `ANDROID_KEYSTORE_PASSWORD` | Le mot de passe du fichier JKS |
| `ANDROID_KEY_ALIAS` | `upload` si la commande ci-dessus a été conservée |
| `ANDROID_KEY_PASSWORD` | Le mot de passe de la clé |

Ne place jamais la clé JKS ni les mots de passe directement dans le dépôt.

## 3. Lancer la génération

Pousse le projet sur la branche `main` ou ouvre **Actions → Construire AAB Play
Store → Run workflow**. Une fois le travail terminé, télécharge l’artefact
**Moi-Geomaticien-PlayStore-AAB**.

Le workflow :

- génère Android si le dossier n’existe pas ;
- ajoute les autorisations de localisation et l’accès CSV compatible Android ;
- applique la nouvelle icône ;
- analyse et teste l’application ;
- signe le bundle avec la clé d’upload ;
- vérifie puis publie `Moi_Geomaticien_PlayStore.aab`.

## 4. Importer dans Play Console

Crée l’application dans Google Play Console avec l’identifiant
`com.novateur221.moi_geomaticien`, active **Play App Signing**, puis importe le
fichier `.aab` dans une piste de test interne avant la production.

Publie aussi le contenu de `POLITIQUE_CONFIDENTIALITE.md` comme page web
publique, non protégée par connexion, puis renseigne son URL dans Play Console.
La même politique est accessible depuis l’onglet Profil de l’application. Une
explication claire précède également la demande système de localisation.

Complète enfin avec exactitude la rubrique **Sécurité des données** selon le
comportement de la version réellement publiée et les éventuels services que tu
ajouterais plus tard.

La version actuelle est `4.0.0+6`. Pour chaque nouvelle livraison, augmente au
minimum le nombre situé après `+` dans `pubspec.yaml`.

## Autorisations et confidentialité

- La localisation est demandée à l’entrée dans l’application puis, si besoin,
  depuis le module Terrain.
- Pour lire un CSV, Android affiche son sélecteur système : l’utilisateur choisit
  lui-même le fichier. L’application n’obtient pas un accès général au stockage.
- Sur les anciens appareils, le manifeste limite l’autorisation de lecture à
  Android 9 et versions antérieures.
