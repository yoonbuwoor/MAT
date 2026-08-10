# Journal des modifications — V4.0.0

## Identité

- Nouveau logo indépendant pour Moi, Géomaticien : balise cartographique,
  viseur de coordonnées et courbes de niveau, avec uniquement le code couleur
  Novateur221.
- Le logo Novateur221 reste inchangé et distinct de celui de l’application.
- Icônes classique et adaptative Android mises à jour.

## Apprentissage

- Bibliothèque portée à 30 cours avec recherche et filtres par domaine.
- Banque portée à 30 quiz avec recherche, niveaux et corrections expliquées.
- Ajout d’un catalogue de logiciels de géomatique et de leurs usages.

## Terrain et fichiers

- Demande de localisation déclenchée à l’entrée dans l’application.
- Permissions Android réellement injectées lors de la génération du projet.
- Nouvelle stratégie de mesure GPS avec seconde tentative et solution de repli.
- Indicateur de qualité de la précision avant enregistrement.
- Import CSV via le sélecteur système Android.
- Export CSV depuis un fichier temporaire partageable, compatible avec le
  stockage cloisonné des versions Android récentes.
- Retrait complet de l’ancien jeu de recherche de cible.

## Google Play

- Correction du conflit de dépendances entre `file_picker` et `share_plus` qui
  bloquait `flutter pub get` avant la génération de l’AAB.
- Verrouillage de `geolocator` en `14.0.2` afin d’éviter la dépendance
  `geolocator_linux 0.2.6` / `package_info_plus 10` qui imposait `win32 6`.

- Version portée à `4.0.0+6`.
- Workflow GitHub Actions consacré au bundle `.aab` signé.
- Configuration sécurisée de la clé d’upload via quatre secrets GitHub.
- Vérification du bundle avant sa publication comme artefact.
