## Mise à jour V1.1

- Nouvel écran d’entrée avec la devise : « Que nul n’entre ici s’il n’est Géomaticien. »
- L’utilisateur valide l’entrée avec le bouton « Entrer dans l’application ».

# Moi, Géomaticien

Application Flutter mobile conçue comme un livre de poche pour les étudiants et professionnels de la géomatique.

## Fonctions incluses

- Tableau de bord « Aujourd'hui »
- Fiches de connaissances et glossaire
- Exercices basés sur des cas pratiques
- Atelier de projet avec workflow guidé
- Carnet de terrain simplifié
- Outils rapides de conversion et de calcul
- SOS Géomaticien pour diagnostiquer les problèmes courants
- Profil de compétences, badges et progression
- Mode clair/sombre
- Contenu entièrement utilisable hors connexion

## Démarrage sur Windows

1. Installer Flutter et Android Studio.
2. Extraire ce dossier.
3. Double-cliquer sur `INSTALLER_ET_LANCER.bat`.
4. Choisir un émulateur ou connecter un téléphone Android.

## Démarrage manuel

```bash
flutter create --org com.novateur221 --project-name moi_geomaticien --platforms=android,web .
flutter pub get
flutter run
```

Le package Android sera `com.novateur221.moi_geomaticien`.

## Remarque

Le projet fourni contient tout le code de l'application et ses ressources. Les dossiers natifs Android/Web sont générés automatiquement par Flutter avec le script d'installation afin de rester compatibles avec la version de Flutter installée sur votre ordinateur.

## Construction automatique de l’APK avec GitHub

Le dossier `.github/workflows` contient une action prête à l’emploi. Après avoir poussé le projet sur GitHub :

1. Ouvrir l’onglet **Actions** du dépôt.
2. Choisir **Construire APK Moi Geomaticien**.
3. Cliquer sur **Run workflow**.
4. Télécharger l’artifact `moi-geomaticien-apk` à la fin du build.
