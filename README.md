# Moi, Géomaticien — Version 4.0

Application Flutter conçue par **Novateur221** comme livre de poche, guide des
logiciels et compagnon de relevé pour les étudiants et professionnels de la
géomatique.

## Nouveautés principales

- nouveau logo propre à Moi, Géomaticien (balise, viseur et courbes de niveau),
  utilisant uniquement le code couleur Novateur221 ;
- 32 cours structurés, des fondamentaux au Web SIG, LiDAR et drone ;
- 30 quiz corrigés, filtrables par niveau ;
- catalogue de logiciels avec utilité, licence, plateforme et meilleur usage ;
- retrait complet de l’ancien jeu de recherche de cible ;
- relevé GPS fiabilisé avec nouvelle tentative et indication de qualité ;
- import de points CSV par le sélecteur de fichiers sécurisé d’Android ;
- export CSV partageable et conservation locale des relevés ;
- génération d’un `.aab` signé pour Google Play.

## Localisation et relevé de points

L’application demande l’autorisation de localisation après l’action d’entrée.
Elle affiche X et Y dans les formats suivants :

- WGS 84 en degrés décimaux ;
- WGS 84 en degrés, minutes et secondes ;
- UTM WGS 84 avec zone et EPSG automatiques ;
- Web Mercator — EPSG:3857.

Chaque point peut contenir un nom, une catégorie, une description, la précision,
l’altitude et des attributs personnalisés. Le relevé est conservé localement.

### Importer un CSV

Le bouton dossier du module **Relever des points** ouvre le sélecteur Android.
L’utilisateur choisit précisément le fichier à lire ; l’application n’accède pas
à tout le stockage. Les colonnes recommandées sont :

```text
nom,categorie,description,longitude_wgs84,latitude_wgs84,precision_m,altitude_m,date_heure
```

Les variantes `longitude`, `lon`, `lng`, `x`, `latitude`, `lat` et `y` sont
également reconnues lorsque les valeurs sont bien en WGS 84.

## Contenus pédagogiques

Les cours couvrent notamment : SCR et EPSG, projections, topologie, jointures,
superpositions, réseaux, géostatistique, télédétection, NDVI/NDWI,
photogrammétrie, MNT/MNS, LiDAR, collecte terrain, PostGIS, SQL spatial, services
OGC, Python, OpenStreetMap, qualité et éthique.

Le catalogue présente les principaux outils de SIG bureautique, télédétection,
base de données, Web SIG, collecte mobile, photogrammétrie et nuages de points.

## Lancer le projet

Utilise Flutter 3.44.9 ou une version compatible avec Dart 3.12, puis exécute :

```bash
flutter create --org com.novateur221 --project-name moi_geomaticien --platforms android .
flutter clean
flutter pub get
python3 tool/configure_android.py
dart run flutter_launcher_icons
flutter run
```

Le script de configuration ajoute les autorisations Android, le nom visible,
l’icône, `minSdk 24` et la configuration de signature release.

## Construire l’APK et l’AAB

Le workflow `.github/workflows/main.yml` génère simultanément
`Moi_Geomaticien_Android.apk` pour l’installation directe et
`Moi_Geomaticien_PlayStore.aab` pour Google Play. La clé d’upload n’est jamais
stockée dans le dépôt : quatre secrets GitHub sont requis.

Les instructions Windows et Play Console se trouvent dans
[`PLAYSTORE_AAB.md`](PLAYSTORE_AAB.md).

## Identité Android

```text
Package : com.novateur221.moi_geomaticien
Version : 4.0.0+7
Format Play Store : Android App Bundle (.aab)
Format installation directe : Android Package (.apk)
```

## Limite de précision

Le GPS d’un téléphone convient à l’apprentissage, au repérage et à certains
inventaires simples. Il ne remplace pas un récepteur GNSS professionnel pour les
travaux cadastraux, topographiques ou centimétriques. La précision affichée doit
toujours être conservée avec le point et interprétée selon la mission.
