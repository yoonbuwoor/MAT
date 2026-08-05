# Moi, Géomaticien — Version 2.0

Application Flutter conçue par Novateur221 comme un compagnon méthodologique pour les étudiants et professionnels de la géomatique.

## Refonte V2

- Nouvelle interface épurée, soignée et plus professionnelle.
- Navigation flottante : Accueil, Fiches, Exercices, Projets et Profil.
- Accueil organisé selon le besoin réel de l’utilisateur, et non comme une grille générique de boutons.
- Explication claire de l’utilité de chaque espace.
- Progression entièrement remise à zéro : aucun score, projet ou pourcentage fictif.
- Carnet de terrain présenté comme une saisie manuelle, sans prétendre récupérer automatiquement le GPS.
- Outils rapides accompagnés de leur contexte d’utilisation et de leurs limites.
- SOS Géomaticien transformé en procédure de diagnostic guidée.
- Logo Moi, Géomaticien utilisé comme icône Android de l’application.
- Mode clair et sombre.

## Écran d’entrée

L’utilisateur voit au lancement :

> Que nul n’entre ici s’il n’est Géomaticien.

## Lancer sur Windows

1. Installer Flutter et Android Studio.
2. Extraire le projet.
3. Double-cliquer sur `INSTALLER_ET_LANCER.bat`.
4. Choisir un émulateur ou connecter un téléphone Android.

Le script génère les dossiers natifs, installe les dépendances, applique le logo comme icône Android et lance l’application.

## Lancer manuellement

```bash
flutter create --org com.novateur221 --project-name moi_geomaticien --platforms=android,web .
flutter pub get
dart run flutter_launcher_icons
flutter run
```

Le package Android est `com.novateur221.moi_geomaticien`.

## Générer l’APK avec GitHub Actions

Le fichier `.github/workflows/main.yml` est prêt.

1. Envoyer le projet sur GitHub.
2. Ouvrir l’onglet **Actions**.
3. Choisir **Construire APK Moi Geomaticien**.
4. Cliquer sur **Run workflow**.
5. Télécharger l’artifact **Moi-Geomaticien-V2-APK**.

L’APK produit se nomme `Moi_Geomaticien_V2.apk`.
