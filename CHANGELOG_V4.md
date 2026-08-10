# Journal des modifications — V4.0.0

## Identité

- Nouveau logo indépendant pour Moi, Géomaticien : balise cartographique,
  viseur de coordonnées et courbes de niveau, avec uniquement le code couleur
  Novateur221.
- Le logo Novateur221 reste inchangé et distinct de celui de l’application.
- Icônes classique et adaptative Android mises à jour.

## Apprentissage

- Bibliothèque portée à 32 cours avec recherche et filtres par domaine.
- Banque portée à 30 quiz avec recherche, niveaux et corrections expliquées.
- Ajout d’un catalogue de logiciels de géomatique et de leurs usages.

## Terrain et fichiers

- Ouverture de l’application garantie même si le service de localisation est
  indisponible, lent, refusé ou bloqué par le téléphone.
- Demande de localisation déclenchée à l’entrée dans l’application.
- Permissions Android réellement injectées lors de la génération du projet.
- Nouvelle stratégie de mesure GPS avec seconde tentative et solution de repli.
- Indicateur de qualité de la précision avant enregistrement.
- Import CSV via le sélecteur système Android.
- Export CSV depuis un fichier temporaire partageable, compatible avec le
  stockage cloisonné des versions Android récentes.
- Retrait complet de l’ancien jeu de recherche de cible.

## Google Play

- Remplacement complet de `file_picker` par `file_selector 1.1.0`, le sélecteur
  officiel Flutter, pour supprimer la régression Android
  `FilePickerPlugin` introuvable.
- Dépendances Android alignées sur Flutter 3.44.9 et le Kotlin intégré :
  `geolocator 14.0.3`, `share_plus 13.3.0` et `file_selector`.
- Nettoyage Flutter ajouté avant chaque résolution et compilation afin d’éviter
  les registrants de plugins périmés.
- Correction du widget contenant le nombre dynamique de cours.

- Version portée à `4.0.0+7` pour la livraison du correctif d’ouverture.
- Workflow GitHub Actions générant simultanément l’APK et l’AAB signés.
- Configuration sécurisée de la clé d’upload via quatre secrets GitHub.
- Vérification des deux fichiers avant leur publication dans un même artefact.
