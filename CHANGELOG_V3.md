# Correctif V3.0.1

- Corrige le conflit de dépendances entre `geolocator 14.0.3` et `share_plus 11.1.0`.
- Met `share_plus` à `^13.3.0`, compatible avec l’API `SharePlus.instance.share(ShareParams(...))` déjà utilisée pour l’export CSV.
- Le workflow Android utilise désormais `flutter create --no-pub` avant le `flutter pub get` contrôlé.
- Version application : `3.0.1+4`.

# Journal des modifications — V3.0

## Interface

- Remplacement de l’onglet Projets par l’onglet Terrain.
- Accueil simplifié autour de l’apprentissage et des usages GPS.
- Suppression des menus et fonctions jugés inutiles ou peu clairs.
- Explication de l’utilité de chaque nouvel écran.

## Localisation

- Ajout de la localisation GPS avec gestion des autorisations Android.
- Ajout de quatre formats de coordonnées.
- Conversion automatique en UTM avec zone, hémisphère et code EPSG.
- Affichage de la précision et de l’altitude.

## Relevés

- Ajout de points nommés avec catégorie, description et attributs personnalisés.
- Sauvegarde locale au format JSON.
- Export CSV avec en-têtes dynamiques.
- Partage du fichier CSV via les applications installées sur le téléphone.

## GéoChasse

- Rayon de 100 m par défaut, réglable jusqu’à 500 m.
- Point secret basé sur un relevé existant, une saisie manuelle ou le GPS.
- Radar, distance, cap, indication chaud/froid et validation automatique.

## Android

- Version `3.0.0+3`.
- Icône Android classique et adaptative basée sur le logo.
- Vérification automatique de `ic_launcher` dans GitHub Actions.
- `minSdk` porté à 24.
- Ajout de `ACCESS_FINE_LOCATION` et `ACCESS_COARSE_LOCATION`.
