import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/app_models.dart';

const learningTopics = <LearningTopic>[
  LearningTopic(
    id: 'projection',
    title: 'Système de projection',
    subtitle: 'Comprendre pourquoi la Terre doit être projetée',
    category: 'Fondamentaux',
    icon: Icons.public,
    color: AppTheme.coral,
    definition:
        'Une projection cartographique est une méthode mathématique qui transforme la surface courbe de la Terre en une représentation plane. Toute projection introduit des déformations : surfaces, distances, directions ou formes.',
    example:
        'Pour mesurer correctement des distances à Dakar, on travaille dans un système projeté adapté à la zone plutôt qu’en latitude et longitude brutes.',
    frequentError:
        'Calculer des distances ou des superficies dans un système géographique exprimé en degrés.',
    proTip:
        'Vérifie toujours le système de coordonnées avant de commencer une analyse spatiale.',
    keyPoints: [
      'Une projection est toujours un compromis.',
      'Le choix dépend de la zone et de l’usage de la carte.',
      'Les unités doivent être cohérentes avec le calcul attendu.',
    ],
  ),
  LearningTopic(
    id: 'buffer',
    title: 'Zone tampon — Buffer',
    subtitle: 'Délimiter une distance autour d’un objet',
    category: 'Analyse spatiale',
    icon: Icons.radio_button_checked,
    color: AppTheme.purple,
    definition:
        'Une zone tampon est une surface générée autour d’un point, d’une ligne ou d’un polygone selon une distance définie.',
    example:
        'Identifier les habitations situées à moins de 500 mètres d’une route principale.',
    frequentError:
        'Créer un buffer en degrés ou oublier de dissoudre les zones qui se chevauchent.',
    proTip:
        'Précise toujours l’unité de distance et justifie le seuil choisi dans ton rapport.',
    keyPoints: [
      'Le buffer répond à une question de proximité.',
      'Il peut être simple, multiple ou variable.',
      'Le résultat doit être interprété selon le contexte.',
    ],
  ),
  LearningTopic(
    id: 'raster_vector',
    title: 'Raster et vecteur',
    subtitle: 'Choisir le bon modèle de données',
    category: 'SIG',
    icon: Icons.grid_on_rounded,
    color: Color(0xFF25858A),
    definition:
        'Le vecteur représente les objets par des points, lignes et polygones. Le raster représente l’espace sous forme d’une grille de cellules.',
    example:
        'Les routes sont généralement stockées en lignes vectorielles, tandis qu’une image satellite est un raster.',
    frequentError:
        'Utiliser un raster trop grossier pour une analyse locale ou vectoriser inutilement une information continue.',
    proTip:
        'Choisis le modèle selon la nature du phénomène, la précision attendue et les traitements prévus.',
    keyPoints: [
      'Vecteur : objets discrets.',
      'Raster : phénomènes continus et imagerie.',
      'La résolution détermine le niveau de détail du raster.',
    ],
  ),
  LearningTopic(
    id: 'semio',
    title: 'Sémiologie graphique',
    subtitle: 'Faire parler une carte sans la surcharger',
    category: 'Cartographie',
    icon: Icons.palette_outlined,
    color: Color(0xFFB36A28),
    definition:
        'La sémiologie graphique organise les formes, couleurs, tailles et valeurs afin de transmettre clairement une information géographique.',
    example:
        'Une progression du clair vers le foncé convient à une variable quantitative ordonnée.',
    frequentError:
        'Employer trop de couleurs, mélanger les niveaux de lecture ou utiliser une palette sans logique.',
    proTip:
        'Lis ta carte à trois distances : miniature, écran normal et zoom. Le message principal doit rester visible.',
    keyPoints: [
      'Une couleur doit avoir une fonction.',
      'La hiérarchie visuelle guide la lecture.',
      'La légende doit expliquer, pas répéter.',
    ],
  ),
  LearningTopic(
    id: 'gnss',
    title: 'Précision GNSS',
    subtitle: 'Comprendre la qualité d’une position',
    category: 'Terrain',
    icon: Icons.gps_fixed,
    color: Color(0xFF4267A8),
    definition:
        'La précision GNSS décrit l’incertitude associée à une position calculée à partir de signaux satellitaires.',
    example:
        'Une précision de 3 mètres peut suffire pour un inventaire simple, mais pas pour implanter une limite cadastrale.',
    frequentError:
        'Confondre la précision affichée par le téléphone avec une garantie absolue de qualité.',
    proTip:
        'Observe la précision, attends sa stabilisation et note les conditions de collecte.',
    keyPoints: [
      'Le matériel et l’environnement influencent la précision.',
      'La précision nécessaire dépend de la mission.',
      'Toujours documenter la méthode de collecte.',
    ],
  ),
  LearningTopic(
    id: 'ndvi',
    title: 'Indice NDVI',
    subtitle: 'Observer la vigueur de la végétation',
    category: 'Télédétection',
    icon: Icons.eco_outlined,
    color: Color(0xFF4A8A4F),
    definition:
        'Le NDVI compare la réflectance dans le proche infrarouge et le rouge pour mettre en évidence l’activité de la végétation.',
    example:
        'Comparer l’état de parcelles agricoles au début et à la fin de la saison des pluies.',
    frequentError:
        'Interpréter l’indice sans tenir compte du sol, des nuages, de la saison ou du capteur.',
    proTip:
        'Ne présente jamais un indice sans expliquer sa date, sa résolution et ses limites.',
    keyPoints: [
      'Le NDVI varie généralement de -1 à 1.',
      'Les valeurs élevées signalent souvent une végétation active.',
      'Une validation terrain renforce l’interprétation.',
    ],
  ),
  LearningTopic(
    id: 'georef',
    title: 'Géoréférencement',
    subtitle: 'Positionner correctement une image ou une carte',
    category: 'SIG',
    icon: Icons.control_point_duplicate,
    color: Color(0xFF8F4F7D),
    definition:
        'Le géoréférencement associe une image à des coordonnées réelles grâce à des points de contrôle.',
    example:
        'Positionner un ancien plan communal sur une orthophoto récente.',
    frequentError:
        'Choisir des points trop proches, mal répartis ou difficiles à identifier précisément.',
    proTip:
        'Répartis les points sur toute l’image et contrôle les résidus avant l’export.',
    keyPoints: [
      'Les points de contrôle doivent être fiables.',
      'La transformation dépend de la déformation du document.',
      'L’erreur résiduelle doit être analysée, pas seulement minimisée.',
    ],
  ),
  LearningTopic(
    id: 'postgis',
    title: 'Base de données spatiale',
    subtitle: 'Organiser et interroger les données géographiques',
    category: 'Données',
    icon: Icons.storage_rounded,
    color: Color(0xFF5D6E7A),
    definition:
        'Une base de données spatiale stocke des géométries, leurs attributs et des relations permettant des requêtes géographiques.',
    example:
        'Trouver toutes les écoles situées dans une commune et à moins de deux kilomètres d’un axe routier.',
    frequentError:
        'Créer des tables sans identifiant stable, métadonnées ou index spatial.',
    proTip:
        'Conçois d’abord le modèle de données avant d’accumuler des fichiers dispersés.',
    keyPoints: [
      'La structure garantit la cohérence.',
      'L’index spatial accélère les requêtes.',
      'Les contraintes préviennent les erreurs.',
    ],
  ),
  LearningTopic(
    id: 'crs_epsg',
    title: 'SCR, datum et code EPSG',
    subtitle: 'Identifier sans ambiguïté le référentiel d’une couche',
    category: 'Fondamentaux',
    icon: Icons.pin_drop_outlined,
    color: AppTheme.purple,
    definition:
        'Un système de référence de coordonnées associe un datum, des axes, des unités et parfois une projection. Le code EPSG permet d’identifier cet ensemble.',
    example:
        'EPSG:4326 désigne le WGS 84 géographique, tandis qu’EPSG:32628 désigne l’UTM zone 28 Nord sur WGS 84.',
    frequentError:
        'Attribuer un SCR au hasard au lieu de reprojeter réellement la couche.',
    proTip:
        'Contrôle l’emprise et les unités : une couche mal déclarée se place souvent très loin de la zone attendue.',
    keyPoints: [
      'Définir un SCR et reprojeter sont deux opérations différentes.',
      'Un code EPSG décrit un référentiel précis.',
      'Les axes et unités doivent être contrôlés.',
    ],
  ),
  LearningTopic(
    id: 'topology',
    title: 'Topologie vectorielle',
    subtitle: 'Détecter les trous, chevauchements et ruptures',
    category: 'SIG',
    icon: Icons.schema_rounded,
    color: Color(0xFF397B76),
    definition:
        'La topologie décrit les relations logiques entre géométries : connexion, voisinage, inclusion et absence de chevauchement.',
    example:
        'Vérifier que deux communes voisines partagent une limite sans vide ni superposition.',
    frequentError:
        'Corriger seulement l’apparence de la carte sans réparer la géométrie.',
    proTip:
        'Définis les règles avant la saisie et lance une validation après chaque campagne de modification.',
    keyPoints: [
      'Les règles dépendent du métier.',
      'L’accrochage limite les erreurs de saisie.',
      'Une géométrie valide n’est pas forcément topologiquement correcte.',
    ],
  ),
  LearningTopic(
    id: 'spatial_join',
    title: 'Jointure spatiale',
    subtitle: 'Transférer des attributs selon une relation géographique',
    category: 'Analyse spatiale',
    icon: Icons.join_inner_rounded,
    color: AppTheme.coral,
    definition:
        'Une jointure spatiale relie des entités selon leur position : contient, intersecte, touche ou se trouve à proximité.',
    example:
        'Associer à chaque école le nom de la commune qui la contient.',
    frequentError:
        'Ignorer les relations multiples lorsqu’un objet intersecte plusieurs zones.',
    proTip:
        'Choisis explicitement la relation et la règle d’agrégation avant d’exécuter le traitement.',
    keyPoints: [
      'La relation remplace une clé attributaire.',
      'Un objet peut produire plusieurs correspondances.',
      'Le résultat doit être contrôlé aux frontières.',
    ],
  ),
  LearningTopic(
    id: 'overlay',
    title: 'Superposition de couches',
    subtitle: 'Croiser intersection, union et différence',
    category: 'Analyse spatiale',
    icon: Icons.filter_none_rounded,
    color: Color(0xFF8F4F7D),
    definition:
        'Les opérations de superposition construisent de nouvelles géométries à partir des relations entre plusieurs couches.',
    example:
        'Intersecter les zones agricoles avec les secteurs exposés à l’érosion.',
    frequentError:
        'Croiser des couches de précision ou de date incompatibles sans le signaler.',
    proTip:
        'Répare les géométries, harmonise le SCR et conserve la provenance des attributs.',
    keyPoints: [
      'Intersection conserve la partie commune.',
      'Union combine toutes les surfaces.',
      'La qualité du résultat dépend des données sources.',
    ],
  ),
  LearningTopic(
    id: 'network_analysis',
    title: 'Analyse de réseau',
    subtitle: 'Calculer itinéraires, dessertes et temps de parcours',
    category: 'Analyse spatiale',
    icon: Icons.alt_route_rounded,
    color: Color(0xFF4267A8),
    definition:
        'L’analyse de réseau modélise les déplacements sur des arcs connectés avec des coûts comme la distance ou le temps.',
    example:
        'Déterminer les quartiers accessibles en moins de quinze minutes depuis un poste de santé.',
    frequentError:
        'Utiliser une distance à vol d’oiseau pour représenter un trajet routier.',
    proTip:
        'Contrôle les sens uniques, les ruptures du réseau, les vitesses et les restrictions.',
    keyPoints: [
      'Le réseau doit être connecté.',
      'Le coût choisi change le résultat.',
      'Une isochrone représente un temps de parcours.',
    ],
  ),
  LearningTopic(
    id: 'interpolation',
    title: 'Interpolation spatiale',
    subtitle: 'Estimer une valeur entre des observations',
    category: 'Géostatistique',
    icon: Icons.bubble_chart_outlined,
    color: Color(0xFF6F5B9C),
    definition:
        'L’interpolation estime une surface continue à partir de mesures ponctuelles en supposant une continuité spatiale.',
    example:
        'Produire une surface indicative de pluviométrie à partir de stations météorologiques.',
    frequentError:
        'Interpoler en dehors de la zone couverte par les observations sans évaluer l’incertitude.',
    proTip:
        'Teste plusieurs paramètres et valide le modèle avec des points laissés de côté.',
    keyPoints: [
      'La densité des points est déterminante.',
      'IDW et krigeage reposent sur des hypothèses différentes.',
      'Toute estimation doit être accompagnée d’une incertitude.',
    ],
  ),
  LearningTopic(
    id: 'spatial_autocorrelation',
    title: 'Autocorrélation spatiale',
    subtitle: 'Mesurer si les valeurs proches se ressemblent',
    category: 'Géostatistique',
    icon: Icons.scatter_plot_rounded,
    color: Color(0xFF7A556F),
    definition:
        'L’autocorrélation spatiale évalue la tendance de valeurs voisines à être similaires ou différentes.',
    example:
        'Tester si les taux élevés d’un phénomène forment des regroupements significatifs.',
    frequentError:
        'Interpréter un agrégat visuel sans test ni matrice de voisinage justifiée.',
    proTip:
        'Documente le voisinage, la pondération et l’échelle d’analyse utilisés.',
    keyPoints: [
      'Moran global décrit une tendance générale.',
      'Les indicateurs locaux repèrent des groupes.',
      'Le résultat dépend de la définition du voisinage.',
    ],
  ),
  LearningTopic(
    id: 'remote_resolution',
    title: 'Résolutions en télédétection',
    subtitle: 'Distinguer spatial, spectral, temporel et radiométrique',
    category: 'Télédétection',
    icon: Icons.satellite_alt_rounded,
    color: Color(0xFF315D8A),
    definition:
        'Un capteur se caractérise par la taille des pixels, les bandes mesurées, la fréquence de revisite et la finesse des niveaux enregistrés.',
    example:
        'Une image à 10 m peut suivre des parcelles, mais pas décrire précisément chaque arbre.',
    frequentError:
        'Choisir une image seulement parce qu’elle est récente sans vérifier sa résolution et ses nuages.',
    proTip:
        'Pars de la taille du phénomène et de la fréquence de suivi nécessaire.',
    keyPoints: [
      'La résolution spatiale décrit la taille du pixel.',
      'La résolution temporelle décrit la revisite.',
      'Plus fin ne signifie pas toujours plus adapté.',
    ],
  ),
  LearningTopic(
    id: 'classification',
    title: 'Classification d’images',
    subtitle: 'Transformer les pixels en classes thématiques',
    category: 'Télédétection',
    icon: Icons.category_rounded,
    color: Color(0xFF4A8A4F),
    definition:
        'La classification attribue une classe à des pixels ou objets selon leurs signatures spectrales et des exemples d’apprentissage.',
    example:
        'Distinguer eau, bâti, végétation et sols nus sur une image Sentinel-2.',
    frequentError:
        'Évaluer le modèle sur les mêmes échantillons que ceux utilisés pour l’entraînement.',
    proTip:
        'Sépare entraînement et validation, puis examine la matrice de confusion.',
    keyPoints: [
      'Les échantillons doivent être représentatifs.',
      'Le prétraitement influence les classes.',
      'Une carte classée nécessite une validation indépendante.',
    ],
  ),
  LearningTopic(
    id: 'ndwi',
    title: 'Indice NDWI',
    subtitle: 'Mettre en évidence l’eau avec prudence',
    category: 'Télédétection',
    icon: Icons.water_drop_outlined,
    color: Color(0xFF4379B8),
    definition:
        'Le NDWI combine des bandes spectrales afin d’accentuer la réponse de l’eau, selon la formule et le capteur choisis.',
    example:
        'Comparer l’extension d’une mare entre deux dates sans nuage.',
    frequentError:
        'Confondre ombres, surfaces sombres et eau sans vérification visuelle ou terrain.',
    proTip:
        'Indique la formule exacte, le seuil, le capteur et la date dans la méthodologie.',
    keyPoints: [
      'Plusieurs variantes du NDWI existent.',
      'Le seuil n’est pas universel.',
      'La validation terrain reste essentielle.',
    ],
  ),
  LearningTopic(
    id: 'photogrammetry',
    title: 'Chaîne photogrammétrique',
    subtitle: 'Passer des images à une orthophoto mesurable',
    category: 'Photogrammétrie',
    icon: Icons.flight_takeoff_rounded,
    color: AppTheme.coral,
    definition:
        'La photogrammétrie reconstruit la géométrie d’une scène à partir d’images qui se recouvrent et de paramètres de caméra.',
    example:
        'Produire une orthomosaïque, un nuage de points et un MNS à partir d’une mission drone.',
    frequentError:
        'Voler sans recouvrement suffisant ni contrôle de l’exposition ou de la vitesse.',
    proTip:
        'Planifie le GSD, les recouvrements, les points de contrôle et les contrôles indépendants avant le vol.',
    keyPoints: [
      'La qualité commence lors de l’acquisition.',
      'Les GCP renforcent le géoréférencement.',
      'Le rapport de traitement doit être analysé.',
    ],
  ),
  LearningTopic(
    id: 'dem_models',
    title: 'MNT, MNS et modèle d’élévation',
    subtitle: 'Choisir la bonne représentation du relief',
    category: '3D et relief',
    icon: Icons.terrain_rounded,
    color: Color(0xFF8A6A3C),
    definition:
        'Le MNS représente la surface visible avec bâtiments et végétation ; le MNT cherche à représenter le sol.',
    example:
        'Utiliser un MNT pour modéliser un écoulement et un MNS pour estimer la hauteur d’objets.',
    frequentError:
        'Employer un MNS non filtré comme terrain nu dans une étude hydraulique.',
    proTip:
        'Vérifie la résolution, le datum vertical, les vides et la méthode de production.',
    keyPoints: [
      'MNT et MNS répondent à des besoins différents.',
      'L’altitude doit avoir une référence verticale.',
      'La résolution ne garantit pas la précision.',
    ],
  ),
  LearningTopic(
    id: 'lidar',
    title: 'Nuages de points LiDAR',
    subtitle: 'Lire, classer et contrôler des millions de points 3D',
    category: '3D et relief',
    icon: Icons.grain_rounded,
    color: Color(0xFF657580),
    definition:
        'Le LiDAR mesure des distances par impulsions laser et produit un nuage de points avec coordonnées, intensité et parfois plusieurs retours.',
    example:
        'Classer le sol, la végétation et les bâtiments avant de générer un MNT.',
    frequentError:
        'Créer un raster sans contrôler la classification, la densité et les zones sans retour.',
    proTip:
        'Inspecte les profils, classes et statistiques avant toute interpolation.',
    keyPoints: [
      'Chaque point porte des attributs utiles.',
      'La classification conditionne les produits dérivés.',
      'La densité varie avec le capteur et le terrain.',
    ],
  ),
  LearningTopic(
    id: 'field_protocol',
    title: 'Protocole de collecte terrain',
    subtitle: 'Produire des points cohérents et traçables',
    category: 'Terrain',
    icon: Icons.assignment_turned_in_outlined,
    color: AppTheme.teal,
    definition:
        'Un protocole décrit qui collecte quoi, avec quel matériel, quels champs, quelles règles et quels contrôles.',
    example:
        'Imposer une liste de catégories, une photo, une précision maximale et un identifiant unique pour chaque équipement.',
    frequentError:
        'Commencer la collecte avant de tester le formulaire et les valeurs autorisées.',
    proTip:
        'Réalise un pilote court, corrige les ambiguïtés puis forme toute l’équipe sur la même version.',
    keyPoints: [
      'Les champs obligatoires réduisent les oublis.',
      'Un identifiant stable évite les doublons.',
      'Le contrôle quotidien limite les reprises.',
    ],
  ),
  LearningTopic(
    id: 'quality_metadata',
    title: 'Qualité et métadonnées',
    subtitle: 'Rendre une donnée compréhensible et réutilisable',
    category: 'Données',
    icon: Icons.fact_check_outlined,
    color: Color(0xFF5D6E7A),
    definition:
        'Les métadonnées décrivent la source, la date, le responsable, la méthode, le SCR, la précision et les limites d’un jeu de données.',
    example:
        'Documenter qu’une couche de routes provient d’un relevé de 2025 avec une précision indicative de cinq mètres.',
    frequentError:
        'Livrer un fichier nommé final_v2 sans source, date ni dictionnaire des champs.',
    proTip:
        'Crée la fiche de métadonnées en même temps que la donnée, pas à la fin.',
    keyPoints: [
      'La qualité dépend de l’usage attendu.',
      'La traçabilité permet d’évaluer la fiabilité.',
      'Un dictionnaire explique les attributs et codes.',
    ],
  ),
  LearningTopic(
    id: 'spatial_sql',
    title: 'SQL spatial',
    subtitle: 'Interroger les géométries dans PostGIS',
    category: 'Données',
    icon: Icons.code_rounded,
    color: Color(0xFF416887),
    definition:
        'Le SQL spatial combine les requêtes classiques avec des fonctions de distance, intersection, transformation et agrégation géographique.',
    example:
        'Compter les points de collecte par commune avec ST_Within et GROUP BY.',
    frequentError:
        'Comparer des géométries de SCR différents ou calculer des distances en degrés.',
    proTip:
        'Utilise des index spatiaux et examine le plan d’exécution sur les grandes tables.',
    keyPoints: [
      'Les fonctions spatiales s’intègrent au SQL.',
      'Le SCR détermine l’unité des calculs.',
      'Un index GiST accélère de nombreuses requêtes.',
    ],
  ),
  LearningTopic(
    id: 'webmapping',
    title: 'Architecture d’une carte web',
    subtitle: 'Comprendre client, serveur, services et tuiles',
    category: 'Web SIG',
    icon: Icons.web_rounded,
    color: Color(0xFF397A72),
    definition:
        'Une application cartographique web combine une interface cliente, des données, des services et parfois un serveur de tuiles.',
    example:
        'Afficher dans Leaflet un fond tuilé et une couche GeoJSON chargée depuis une API.',
    frequentError:
        'Envoyer au navigateur un fichier trop volumineux sans simplification ni pagination.',
    proTip:
        'Adapte le format et le niveau de détail à l’échelle d’affichage.',
    keyPoints: [
      'Le client affiche et interagit.',
      'Le serveur prépare ou diffuse les données.',
      'Les performances se conçoivent dès l’architecture.',
    ],
  ),
  LearningTopic(
    id: 'ogc_services',
    title: 'Services OGC : WMS, WFS et WCS',
    subtitle: 'Choisir entre image, objets et couverture raster',
    category: 'Web SIG',
    icon: Icons.dns_outlined,
    color: Color(0xFF3E7D61),
    definition:
        'Les standards OGC permettent d’échanger des cartes rendues, des objets vectoriels ou des couvertures raster entre logiciels.',
    example:
        'Utiliser WMS pour afficher une carte et WFS pour interroger les géométries et attributs.',
    frequentError:
        'Demander toutes les entités d’un WFS national sans filtre ni emprise.',
    proTip:
        'Teste les capacités, le SCR, les limites et le temps de réponse du service.',
    keyPoints: [
      'WMS fournit principalement une image.',
      'WFS fournit des objets géographiques.',
      'WCS diffuse des données raster exploitables.',
    ],
  ),
  LearningTopic(
    id: 'python_geo',
    title: 'Automatisation avec Python',
    subtitle: 'Transformer une suite de clics en traitement reproductible',
    category: 'Programmation',
    icon: Icons.terminal_rounded,
    color: Color(0xFF4D6C91),
    definition:
        'Python permet de lire, contrôler, analyser et exporter des données géographiques avec des bibliothèques spécialisées.',
    example:
        'Parcourir cent fichiers, harmoniser leur SCR et produire automatiquement un rapport de contrôle.',
    frequentError:
        'Écrire un script sans validation des entrées, journalisation ni environnement de dépendances.',
    proTip:
        'Commence par automatiser une tâche répétitive simple et teste-la sur une copie des données.',
    keyPoints: [
      'Un script rend le traitement reproductible.',
      'Les erreurs doivent être explicites.',
      'Les versions des bibliothèques doivent être conservées.',
    ],
  ),
  LearningTopic(
    id: 'osm',
    title: 'OpenStreetMap et données collaboratives',
    subtitle: 'Contribuer, vérifier et citer une base ouverte',
    category: 'Cartographie',
    icon: Icons.edit_location_alt_outlined,
    color: Color(0xFF4B8B48),
    definition:
        'OpenStreetMap est une base géographique collaborative structurée par des objets, des clés et des valeurs.',
    example:
        'Ajouter un centre de santé avec sa géométrie, son nom et des attributs vérifiés sur le terrain.',
    frequentError:
        'Copier des données protégées ou ajouter un objet sans source vérifiable.',
    proTip:
        'Lis le wiki des attributs, utilise des images autorisées et contrôle les conflits avant l’envoi.',
    keyPoints: [
      'Les tags donnent le sens aux objets.',
      'La source et la date doivent être traçables.',
      'La communauté assure une partie du contrôle qualité.',
    ],
  ),
  LearningTopic(
    id: 'geocoding',
    title: 'Géocodage et géocodage inverse',
    subtitle: 'Relier adresses, lieux et coordonnées',
    category: 'Données',
    icon: Icons.location_searching_rounded,
    color: AppTheme.orange,
    definition:
        'Le géocodage transforme un texte de lieu en coordonnées ; le géocodage inverse cherche une adresse à partir d’une position.',
    example:
        'Positionner une liste de services à partir de leurs adresses normalisées.',
    frequentError:
        'Accepter automatiquement le premier résultat sans score ni contrôle territorial.',
    proTip:
        'Conserve le texte initial, le fournisseur, le score et le résultat choisi.',
    keyPoints: [
      'Une adresse ambiguë peut produire plusieurs résultats.',
      'Le référentiel d’adresses influence la qualité.',
      'Les résultats sensibles doivent être vérifiés.',
    ],
  ),
  LearningTopic(
    id: 'map_layout',
    title: 'Mise en page cartographique',
    subtitle: 'Construire un document lisible et hiérarchisé',
    category: 'Cartographie',
    icon: Icons.dashboard_customize_outlined,
    color: Color(0xFFB36A28),
    definition:
        'La mise en page organise carte, titre, légende, échelle, sources et informations utiles selon un objectif de communication.',
    example:
        'Préparer une carte A4 dont le message principal reste compréhensible une fois imprimé.',
    frequentError:
        'Ajouter une flèche nord, une échelle ou une légende sans vérifier leur utilité et leur exactitude.',
    proTip:
        'Teste le PDF au format final et demande à une personne extérieure de formuler le message lu.',
    keyPoints: [
      'Le titre doit exprimer le sujet, le lieu et si utile la date.',
      'Les sources et le SCR assurent la traçabilité.',
      'La hiérarchie visuelle guide le regard.',
    ],
  ),
  LearningTopic(
    id: 'privacy',
    title: 'Éthique et données géolocalisées',
    subtitle: 'Protéger les personnes derrière les points',
    category: 'Méthodologie',
    icon: Icons.privacy_tip_outlined,
    color: Color(0xFF7A556F),
    definition:
        'Une donnée géographique peut révéler une identité, un domicile, une habitude ou une vulnérabilité même sans afficher un nom.',
    example:
        'Agréger des observations sensibles par zone plutôt que publier les coordonnées exactes.',
    frequentError:
        'Mettre en ligne le fichier brut parce qu’il ne contient pas de colonne nom.',
    proTip:
        'Minimise les données, contrôle les accès et documente la durée de conservation.',
    keyPoints: [
      'La localisation peut être une donnée personnelle.',
      'La précision publiée doit être justifiée.',
      'Le consentement ne remplace pas la sécurité.',
    ],
  ),
  LearningTopic(
    id: 'project_method',
    title: 'Conduire un projet géomatique',
    subtitle: 'Partir du besoin avant de choisir les outils',
    category: 'Méthodologie',
    icon: Icons.account_tree_outlined,
    color: AppTheme.purple,
    definition:
        'Un projet géomatique relie une question métier, des utilisateurs, des données, des traitements, des livrables et des critères de réussite.',
    example:
        'Définir les décisions que doit permettre une carte avant de lancer la collecte.',
    frequentError:
        'Commencer par choisir un logiciel ou produire une carte sans besoin validé.',
    proTip:
        'Rédige une note d’une page : problème, utilisateurs, données, méthode, résultat et validation.',
    keyPoints: [
      'Le besoin pilote les choix techniques.',
      'Un prototype réduit les risques.',
      'La validation doit être prévue dès le départ.',
    ],
  ),
];


const glossary = <String, String>{
  'Analyse spatiale':
      'Ensemble de méthodes permettant d’étudier les relations, répartitions et proximités entre objets géographiques.',
  'Attribut':
      'Information descriptive associée à un objet géographique, par exemple le nom, le type ou l’état d’un équipement.',
  'Azimut':
      'Angle horizontal mesuré depuis le nord, généralement dans le sens horaire, pour exprimer une direction.',
  'Buffer':
      'Zone tampon créée à une distance donnée autour d’un point, d’une ligne ou d’un polygone.',
  'Datum':
      'Référence géodésique utilisée pour définir la position d’un système de coordonnées par rapport à la Terre.',
  'EPSG':
      'Code normalisé permettant d’identifier précisément un système de référence de coordonnées.',
  'Géocodage':
      'Opération qui transforme une adresse ou un nom de lieu en coordonnées géographiques.',
  'Géoréférencement':
      'Opération qui associe une image, un plan ou une carte à des coordonnées réelles.',
  'GNSS':
      'Ensemble des systèmes mondiaux de navigation par satellites utilisés pour déterminer une position.',
  'MNS':
      'Modèle numérique de surface représentant l’altitude du sol et des objets présents au-dessus, comme les bâtiments ou la végétation.',
  'MNT':
      'Modèle numérique de terrain représentant l’altitude du sol en limitant autant que possible les objets situés au-dessus.',
  'NDVI':
      'Indice spectral utilisant le rouge et le proche infrarouge pour caractériser l’activité de la végétation.',
  'Projection cartographique':
      'Méthode mathématique transformant la surface courbe de la Terre en une représentation plane.',
  'Raster':
      'Modèle de données géographiques constitué d’une grille de cellules ou pixels.',
  'Résolution spatiale':
      'Dimension du plus petit détail observable dans une donnée raster ou une image.',
  'SIG':
      'Système d’information géographique permettant de stocker, analyser, croiser et représenter des données localisées.',
  'Topologie':
      'Ensemble des règles décrivant les relations spatiales entre objets, comme la connexion, l’adjacence ou l’inclusion.',
  'UTM':
      'Système de projection mondial découpant la Terre en zones et exprimant les coordonnées principalement en mètres.',
  'Vecteur':
      'Modèle de données représentant les objets géographiques par des points, des lignes et des polygones.',
  'WGS 84':
      'Système géodésique mondial couramment utilisé par le GPS pour exprimer latitude et longitude.',
  'Web Mercator':
      'Projection très utilisée dans les fonds de cartes web, identifiée notamment par le code EPSG:3857.',
};

const practiceMissions = <PracticeMission>[
  PracticeMission(
    id: 'flood',
    title: 'Cartographier le risque d’inondation',
    scenario:
        'Une commune souhaite identifier les quartiers potentiellement exposés aux inondations. Quelle combinaison de données est la plus pertinente pour commencer ?',
    category: 'Analyse spatiale',
    level: 'Intermédiaire',
    icon: Icons.water,
    options: [
      'Relief, hydrographie, occupation du sol et historique des zones inondées',
      'Photographies des bâtiments et noms des rues uniquement',
      'Limites administratives et logo de la commune',
      'Population totale du pays sans localisation',
    ],
    correctIndex: 0,
    explanation:
        'Le relief, les écoulements, l’imperméabilisation du sol et les observations historiques permettent de construire une première analyse cohérente de l’exposition.',
  ),
  PracticeMission(
    id: 'projection_choice',
    title: 'Choisir une projection',
    scenario:
        'Tu dois calculer la superficie de parcelles dans une zone urbaine. Quelle action est indispensable ?',
    category: 'Fondamentaux',
    level: 'Débutant',
    icon: Icons.straighten,
    options: [
      'Utiliser directement les coordonnées en degrés',
      'Reprojeter les données dans un système métrique adapté à la zone',
      'Transformer les polygones en images JPEG',
      'Supprimer les informations de projection',
    ],
    correctIndex: 1,
    explanation:
        'Un système projeté adapté fournit des unités métriques et réduit les erreurs de mesure à l’échelle de la zone étudiée.',
  ),
  PracticeMission(
    id: 'bad_map',
    title: 'Diagnostiquer une mauvaise carte',
    scenario:
        'Une carte utilise douze couleurs très saturées pour représenter une variable ordonnée de faible à forte. Quelle correction est prioritaire ?',
    category: 'Cartographie',
    level: 'Débutant',
    icon: Icons.map_outlined,
    options: [
      'Ajouter encore plus de couleurs',
      'Supprimer le titre',
      'Utiliser une gamme progressive claire à foncée',
      'Remplacer la légende par un paragraphe',
    ],
    correctIndex: 2,
    explanation:
        'Une variable ordonnée se lit mieux avec une progression visuelle cohérente, généralement du clair vers le foncé.',
  ),
  PracticeMission(
    id: 'access_health',
    title: 'Analyser l’accès aux centres de santé',
    scenario:
        'Quel résultat répond le mieux à une étude d’accessibilité aux centres de santé ?',
    category: 'Analyse de réseau',
    level: 'Avancé',
    icon: Icons.local_hospital_outlined,
    options: [
      'Une carte des noms de quartiers seulement',
      'Une photographie de chaque centre',
      'Le nombre de routes dans tout le pays',
      'Des temps de parcours calculés sur le réseau routier et croisés avec la population',
    ],
    correctIndex: 3,
    explanation:
        'L’accessibilité dépend des déplacements réels. Le réseau routier, les temps de parcours et la population desservie apportent une réponse opérationnelle.',
  ),
  PracticeMission(
    id: 'assign_vs_reproject',
    title: 'Déclarer ou reprojeter ?',
    scenario:
        'Une couche est correctement placée en WGS 84, mais tu dois la mesurer en mètres. Quelle opération choisir ?',
    category: 'Fondamentaux',
    level: 'Débutant',
    icon: Icons.swap_horiz_rounded,
    options: [
      'La reprojeter vers un SCR métrique adapté',
      'Changer seulement son nom de fichier',
      'Lui attribuer au hasard EPSG:3857',
      'Supprimer son fichier de projection',
    ],
    correctIndex: 0,
    explanation:
        'Reprojeter transforme les coordonnées. Attribuer un SCR ne doit servir qu’à déclarer le référentiel réel d’une couche mal renseignée.',
  ),
  PracticeMission(
    id: 'buffer_units',
    title: 'Créer un buffer de 500 mètres',
    scenario:
        'Ta couche est en EPSG:4326 et tu veux une zone tampon fiable de 500 m. Que faire d’abord ?',
    category: 'Analyse spatiale',
    level: 'Débutant',
    icon: Icons.radio_button_checked_rounded,
    options: [
      'Saisir 500 degrés',
      'Reprojeter vers un SCR métrique adapté',
      'Convertir la couche en image',
      'Masquer la colonne latitude',
    ],
    correctIndex: 1,
    explanation:
        'EPSG:4326 utilise des degrés. Une projection locale métrique permet d’appliquer une distance cohérente.',
  ),
  PracticeMission(
    id: 'topology_overlap',
    title: 'Contrôler des limites communales',
    scenario:
        'Deux communes voisines ne doivent ni se chevaucher ni laisser de vide. Quel contrôle est le plus pertinent ?',
    category: 'SIG',
    level: 'Intermédiaire',
    icon: Icons.schema_rounded,
    options: [
      'Une augmentation de la saturation des couleurs',
      'Un export en JPEG',
      'Une règle topologique de non-chevauchement et couverture',
      'Un tri alphabétique des communes',
    ],
    correctIndex: 2,
    explanation:
        'La topologie contrôle les relations entre les géométries et révèle les chevauchements, trous ou limites incohérentes.',
  ),
  PracticeMission(
    id: 'georef_points',
    title: 'Choisir des points de contrôle',
    scenario:
        'Tu géoréférences un plan ancien. Quelle disposition des points de contrôle est préférable ?',
    category: 'SIG',
    level: 'Intermédiaire',
    icon: Icons.control_point_duplicate_rounded,
    options: [
      'Tous les points dans un même coin',
      'Un seul point au centre',
      'Des points choisis uniquement sur des textes',
      'Des points bien identifiables répartis sur toute l’image',
    ],
    correctIndex: 3,
    explanation:
        'Une bonne répartition limite les déformations locales et permet de contrôler les résidus sur l’ensemble du document.',
  ),
  PracticeMission(
    id: 'gnss_precision',
    title: 'Accepter une précision GNSS',
    scenario:
        'Le téléphone affiche une précision estimée de ±35 m pour relever une borne. Quelle décision est professionnelle ?',
    category: 'Terrain',
    level: 'Débutant',
    icon: Icons.gps_fixed_rounded,
    options: [
      'Attendre, améliorer les conditions ou utiliser un GNSS adapté',
      'Enregistrer sans rien noter',
      'Modifier manuellement la précision à 1 m',
      'Prendre une capture d’écran puis supprimer la mesure',
    ],
    correctIndex: 0,
    explanation:
        'Une borne exige généralement une précision supérieure à celle d’un téléphone. La précision affichée doit être contrôlée et documentée.',
  ),
  PracticeMission(
    id: 'utm_dakar',
    title: 'Identifier la zone UTM de Dakar',
    scenario:
        'Pour des données WGS 84 autour de Dakar, quelle zone UTM nord est généralement appropriée ?',
    category: 'Fondamentaux',
    level: 'Intermédiaire',
    icon: Icons.grid_4x4_rounded,
    options: ['Zone 18N', 'Zone 28N', 'Zone 38S', 'Zone 60N'],
    correctIndex: 1,
    explanation:
        'Dakar se situe dans la zone UTM 28 Nord ; sur WGS 84, le code couramment utilisé est EPSG:32628.',
  ),
  PracticeMission(
    id: 'raster_resolution',
    title: 'Choisir une résolution raster',
    scenario:
        'Tu veux distinguer des objets de deux mètres. Une image dont les pixels mesurent trente mètres est-elle adaptée ?',
    category: 'Télédétection',
    level: 'Débutant',
    icon: Icons.grid_on_rounded,
    options: [
      'Oui, toujours',
      'Oui si la carte est imprimée en A3',
      'Non, le pixel est bien plus grand que l’objet',
      'Seulement après conversion en PDF',
    ],
    correctIndex: 2,
    explanation:
        'La résolution spatiale doit être cohérente avec la taille du phénomène. Un pixel de 30 m ne décrit pas directement un objet de 2 m.',
  ),
  PracticeMission(
    id: 'ndvi_formula',
    title: 'Interpréter le NDVI',
    scenario:
        'Une parcelle obtient un NDVI élevé. Quelle conclusion est la plus prudente ?',
    category: 'Télédétection',
    level: 'Intermédiaire',
    icon: Icons.eco_rounded,
    options: [
      'La parcelle a forcément un rendement élevé',
      'Le sol est nécessairement inondé',
      'L’image ne contient aucun nuage',
      'La végétation semble active, à confirmer avec le contexte et le terrain',
    ],
    correctIndex: 3,
    explanation:
        'Le NDVI renseigne sur la réponse spectrale de la végétation, mais son interprétation dépend de la saison, du capteur, du sol et des observations terrain.',
  ),
  PracticeMission(
    id: 'ndwi_threshold',
    title: 'Extraire l’eau avec un indice',
    scenario:
        'Après calcul du NDWI, que faut-il faire avant de publier les surfaces en eau ?',
    category: 'Télédétection',
    level: 'Intermédiaire',
    icon: Icons.water_drop_rounded,
    options: [
      'Valider le seuil et distinguer ombres, sols sombres et eau',
      'Utiliser le même seuil partout sans contrôle',
      'Supprimer les métadonnées',
      'Arrondir toutes les valeurs à 1',
    ],
    correctIndex: 0,
    explanation:
        'Un indice ne constitue pas à lui seul une vérité terrain. Le seuil et les confusions doivent être validés.',
  ),
  PracticeMission(
    id: 'classification_validation',
    title: 'Valider une classification',
    scenario:
        'Comment évaluer honnêtement une classification supervisée ?',
    category: 'Télédétection',
    level: 'Avancé',
    icon: Icons.category_rounded,
    options: [
      'Avec les mêmes pixels que l’entraînement uniquement',
      'Avec des échantillons indépendants et une matrice de confusion',
      'Avec la couleur préférée du cartographe',
      'En comptant le nombre de fichiers produits',
    ],
    correctIndex: 1,
    explanation:
        'Une validation indépendante mesure les erreurs de confusion et évite une estimation trop optimiste des performances.',
  ),
  PracticeMission(
    id: 'photo_overlap',
    title: 'Planifier un vol photogrammétrique',
    scenario:
        'Pourquoi prévoir un recouvrement frontal et latéral suffisant entre les images ?',
    category: 'Photogrammétrie',
    level: 'Intermédiaire',
    icon: Icons.flight_takeoff_rounded,
    options: [
      'Pour réduire le nombre de correspondances',
      'Pour supprimer le besoin de géoréférencement',
      'Pour permettre la reconstruction et limiter les trous',
      'Pour changer la météo',
    ],
    correctIndex: 2,
    explanation:
        'Le logiciel a besoin de détails communs entre plusieurs images pour estimer les poses et reconstruire la scène.',
  ),
  PracticeMission(
    id: 'gcp_checkpoint',
    title: 'Distinguer GCP et point de contrôle',
    scenario:
        'Dans un projet drone, pourquoi garder certains points mesurés comme checkpoints ?',
    category: 'Photogrammétrie',
    level: 'Avancé',
    icon: Icons.gps_not_fixed_rounded,
    options: [
      'Pour les utiliser dans l’ajustement et dans l’évaluation en même temps',
      'Pour remplacer toutes les images',
      'Pour décorer l’orthophoto',
      'Pour évaluer indépendamment l’exactitude du résultat',
    ],
    correctIndex: 3,
    explanation:
        'Un checkpoint n’est pas utilisé pour contraindre le modèle ; il sert à mesurer l’erreur sur une référence indépendante.',
  ),
  PracticeMission(
    id: 'lidar_ground',
    title: 'Produire un MNT depuis un LiDAR',
    scenario:
        'Quelle classe de points faut-il prioritairement utiliser pour interpoler le terrain nu ?',
    category: '3D et relief',
    level: 'Intermédiaire',
    icon: Icons.grain_rounded,
    options: [
      'Les points classés sol',
      'Les points de toiture uniquement',
      'Tous les points sans contrôle',
      'Les étiquettes textuelles',
    ],
    correctIndex: 0,
    explanation:
        'Le MNT vise le terrain nu. Il faut donc contrôler et utiliser la classe sol, puis traiter les vides et anomalies.',
  ),
  PracticeMission(
    id: 'mnt_mns_choice',
    title: 'Choisir entre MNT et MNS',
    scenario:
        'Tu veux modéliser l’écoulement de l’eau au sol en ville. Quel produit est le point de départ le plus adapté ?',
    category: '3D et relief',
    level: 'Intermédiaire',
    icon: Icons.terrain_rounded,
    options: [
      'Une photographie sans coordonnées',
      'Un MNT contrôlé et adapté à l’hydrologie',
      'Un MNS non filtré sans vérification',
      'Une liste de noms de rues',
    ],
    correctIndex: 1,
    explanation:
        'Un MNT cherche à décrire le terrain. Il doit néanmoins être préparé et validé selon les besoins du modèle hydraulique.',
  ),
  PracticeMission(
    id: 'sql_distance',
    title: 'Calculer une distance dans PostGIS',
    scenario:
        'Tes géométries sont en EPSG:4326. Comment obtenir une distance fiable en mètres ?',
    category: 'Base de données',
    level: 'Avancé',
    icon: Icons.storage_rounded,
    options: [
      'Additionner latitude et longitude',
      'Renommer la colonne geometry en distance',
      'Utiliser une géographie ou transformer vers un SCR métrique adapté',
      'Exporter la table en image',
    ],
    correctIndex: 2,
    explanation:
        'Les coordonnées géographiques sont angulaires. Le type geography ou une projection métrique adaptée permet un calcul cohérent.',
  ),
  PracticeMission(
    id: 'spatial_index',
    title: 'Accélérer une requête spatiale',
    scenario:
        'Une table PostGIS contient plusieurs millions de géométries et les intersections sont lentes. Quelle action est prioritaire ?',
    category: 'Base de données',
    level: 'Avancé',
    icon: Icons.speed_rounded,
    options: [
      'Ajouter des couleurs à la table',
      'Dupliquer chaque ligne',
      'Supprimer le SCR',
      'Créer un index spatial et examiner le plan d’exécution',
    ],
    correctIndex: 3,
    explanation:
        'Un index spatial permet de réduire les candidats examinés ; le plan d’exécution confirme s’il est réellement utilisé.',
  ),
  PracticeMission(
    id: 'join_commune',
    title: 'Associer chaque école à sa commune',
    scenario:
        'Tu possèdes des points écoles et des polygones communaux sans identifiant commun. Quel traitement utiliser ?',
    category: 'Analyse spatiale',
    level: 'Débutant',
    icon: Icons.join_inner_rounded,
    options: [
      'Une jointure spatiale par inclusion',
      'Un tri par couleur',
      'Une conversion en audio',
      'Une interpolation des noms',
    ],
    correctIndex: 0,
    explanation:
        'La relation spatiale contient/est dans permet de transférer le nom de la commune à chaque point école.',
  ),
  PracticeMission(
    id: 'overlay_exposure',
    title: 'Croiser enjeux et aléa',
    scenario:
        'Quelle opération permet d’extraire les bâtiments situés dans une zone d’aléa ?',
    category: 'Analyse spatiale',
    level: 'Débutant',
    icon: Icons.filter_none_rounded,
    options: [
      'Une rotation de la carte',
      'Une intersection ou sélection spatiale',
      'Un géocodage inverse',
      'Une conversion en DMS',
    ],
    correctIndex: 1,
    explanation:
        'Une relation d’intersection identifie les enjeux spatialement concernés par l’emprise de l’aléa.',
  ),
  PracticeMission(
    id: 'interpolation_validation',
    title: 'Contrôler une interpolation',
    scenario:
        'Quel moyen aide à évaluer la qualité d’une surface interpolée ?',
    category: 'Géostatistique',
    level: 'Avancé',
    icon: Icons.bubble_chart_rounded,
    options: [
      'Le nombre de couleurs de la légende',
      'La taille du logo',
      'Une validation croisée et l’analyse des résidus',
      'L’ordre alphabétique des points',
    ],
    correctIndex: 2,
    explanation:
        'La validation croisée compare les observations aux estimations et révèle biais, dispersion et points problématiques.',
  ),
  PracticeMission(
    id: 'metadata_delivery',
    title: 'Livrer une donnée réutilisable',
    scenario:
        'Quel ensemble doit accompagner une couche finale ?',
    category: 'Qualité',
    level: 'Débutant',
    icon: Icons.fact_check_rounded,
    options: [
      'Seulement une capture d’écran',
      'Le mot final dans le nom du fichier',
      'Uniquement le logo du projet',
      'Source, date, méthode, SCR, précision, responsable et dictionnaire des champs',
    ],
    correctIndex: 3,
    explanation:
        'Ces métadonnées permettent d’évaluer l’adéquation, la traçabilité et les limites de la donnée.',
  ),
  PracticeMission(
    id: 'csv_lon_lat',
    title: 'Importer un CSV de coordonnées',
    scenario:
        'Dans un fichier WGS 84, quelle association est généralement correcte pour X et Y ?',
    category: 'Données',
    level: 'Débutant',
    icon: Icons.table_chart_rounded,
    options: [
      'X = longitude et Y = latitude',
      'X = latitude et Y = longitude dans tous les logiciels',
      'X = altitude et Y = précision',
      'X et Y sont toujours des noms',
    ],
    correctIndex: 0,
    explanation:
        'Dans un repère géographique courant, l’axe X correspond à la longitude et Y à la latitude ; il faut néanmoins contrôler le SCR et les en-têtes.',
  ),
  PracticeMission(
    id: 'wms_wfs',
    title: 'Choisir WMS ou WFS',
    scenario:
        'Tu dois télécharger les géométries et attributs d’une couche publiée. Quel service privilégier ?',
    category: 'Web SIG',
    level: 'Intermédiaire',
    icon: Icons.dns_rounded,
    options: ['WMS image uniquement', 'WFS', 'Une capture PNG', 'Un fichier audio'],
    correctIndex: 1,
    explanation:
        'WFS fournit des objets géographiques et leurs attributs, tandis que WMS fournit principalement une représentation cartographique rendue.',
  ),
  PracticeMission(
    id: 'web_performance',
    title: 'Alléger une carte web',
    scenario:
        'Une couche GeoJSON de 200 Mo bloque les téléphones. Quelle approche est la plus saine ?',
    category: 'Web SIG',
    level: 'Avancé',
    icon: Icons.web_rounded,
    options: [
      'Ajouter une animation au chargement',
      'Dupliquer le fichier',
      'Simplifier, filtrer par emprise ou utiliser des tuiles/API',
      'Afficher toutes les étiquettes à toutes les échelles',
    ],
    correctIndex: 2,
    explanation:
        'Il faut réduire la quantité de données envoyée au client et adapter le niveau de détail à l’emprise et au zoom.',
  ),
  PracticeMission(
    id: 'osm_source',
    title: 'Contribuer à OpenStreetMap',
    scenario:
        'Quelle pratique est acceptable pour ajouter un bâtiment ?',
    category: 'Cartographie collaborative',
    level: 'Débutant',
    icon: Icons.edit_location_alt_rounded,
    options: [
      'Copier une carte protégée sans autorisation',
      'Inventer la forme pour compléter la zone',
      'Ajouter un nom non vérifié',
      'Utiliser une observation ou une imagerie autorisée et citer la source',
    ],
    correctIndex: 3,
    explanation:
        'La contribution doit respecter les licences, s’appuyer sur une source vérifiable et suivre les conventions de la communauté.',
  ),
  PracticeMission(
    id: 'field_pilot',
    title: 'Préparer une campagne terrain',
    scenario:
        'Avant d’envoyer vingt enquêteurs, quelle étape réduit le plus les erreurs de collecte ?',
    category: 'Terrain',
    level: 'Intermédiaire',
    icon: Icons.assignment_turned_in_rounded,
    options: [
      'Tester un pilote, corriger le formulaire et former l’équipe',
      'Changer le logo du formulaire chaque jour',
      'Laisser chacun inventer ses catégories',
      'Attendre la fin pour contrôler les données',
    ],
    correctIndex: 0,
    explanation:
        'Un pilote révèle les ambiguïtés et difficultés réelles avant qu’elles ne se multiplient sur toute la campagne.',
  ),
  PracticeMission(
    id: 'location_privacy',
    title: 'Publier des données sensibles',
    scenario:
        'Des points localisent précisément des personnes vulnérables. Quelle publication est la plus responsable ?',
    category: 'Éthique',
    level: 'Avancé',
    icon: Icons.privacy_tip_rounded,
    options: [
      'Publier les coordonnées brutes sans noms',
      'Agréger ou dégrader la précision et contrôler les accès',
      'Ajouter davantage d’attributs personnels',
      'Partager le fichier dans un groupe public',
    ],
    correctIndex: 1,
    explanation:
        'La position peut permettre une ré-identification. La minimisation, l’agrégation et le contrôle d’accès réduisent le risque.',
  ),
];
