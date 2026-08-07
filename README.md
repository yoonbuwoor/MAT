# Moi, Géomaticien — Version 3.0

Application Flutter conçue par Novateur221 comme un livre de poche et un compagnon terrain pour les étudiants et professionnels de la géomatique.

## Ce qui change dans la V3

Les fonctions suivantes ont été retirées :

- recherche et filtres par domaine ;
- atelier guidé de création de projet ;
- liste de contrôle cartographique ;
- ancien carnet de terrain ;
- anciens convertisseurs rapides ;
- SOS Géomaticien.

## Nouvelles fonctions terrain

### Ma localisation

- lecture de la position GPS du téléphone ;
- affichage de X et Y selon le système choisi ;
- WGS 84 en degrés décimaux ;
- WGS 84 en degrés, minutes et secondes ;
- UTM WGS 84 avec zone et EPSG déterminés automatiquement ;
- Web Mercator EPSG:3857 ;
- affichage de la précision et de l’altitude ;
- copie rapide des coordonnées.

### Relever des points

- nom du point ;
- catégorie et description ;
- X, Y, altitude et précision ;
- attributs personnalisés libres ;
- conservation locale des points ;
- suppression individuelle ou totale ;
- export de tous les points en CSV ;
- conservation des longitude/latitude WGS 84 dans chaque export.

### GéoChasse

- création d’un point secret depuis un point enregistré, des coordonnées manuelles ou la position actuelle ;
- rayon de réussite de 100 m par défaut ;
- rayon réglable de 20 à 500 m ;
- coordonnées de la cible masquées pendant le jeu ;
- radar visuel ;
- distance restante ;
- cap indicatif ;
- indicateur chaud/froid ;
- indice facultatif ;
- message de victoire quand le joueur entre dans le rayon.

## Icône Android corrigée

Le logo Moi, Géomaticien est configuré comme icône Android classique et adaptative. Le workflow :

1. crée Android si nécessaire ;
2. ajoute les permissions GPS ;
3. impose le nom « Moi, Géomaticien » ;
4. génère les ressources `ic_launcher` ;
5. vérifie que l’icône existe avant de compiler l’APK.

Lors du premier test de cette V3, désinstalle l’ancienne application du téléphone avant d’installer le nouvel APK. Cela évite qu’un ancien raccourci ou le cache du lanceur conserve l’icône précédente.

## Écran d’entrée

L’utilisateur voit toujours au lancement :

> Que nul n’entre ici s’il n’est Géomaticien.

## Lancer sous Windows

1. Installer Flutter, Android Studio, Java 17 et Python.
2. Extraire le projet.
3. Double-cliquer sur `INSTALLER_ET_LANCER.bat`.
4. Autoriser la localisation lors du premier relevé.

Le script génère Android, applique les permissions, installe les dépendances et génère le logo de l’application.

## Construire avec GitHub Actions

Le fichier `.github/workflows/main.yml` est prêt.

1. Envoyer le contenu du projet sur GitHub.
2. Ouvrir l’onglet **Actions**.
3. Choisir **Construire APK Moi Geomaticien V3**.
4. Cliquer sur **Run workflow**.
5. Télécharger l’artifact **Moi-Geomaticien-V3-APK**.

L’APK produit se nomme :

```text
Moi_Geomaticien_V3.apk
```

## Package Android

```text
com.novateur221.moi_geomaticien
```

## Précision importante

Le GPS d’un téléphone est adapté à l’apprentissage, au repérage et aux inventaires simples. Il ne remplace pas un récepteur GNSS professionnel pour les travaux cadastraux, topographiques ou centimétriques.
