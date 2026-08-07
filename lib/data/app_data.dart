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
];

const practiceMissions = <PracticeMission>[
  PracticeMission(
    id: 'flood',
    title: 'Cartographier le risque d’inondation',
    scenario:
        'Une commune souhaite identifier les quartiers potentiellement exposés aux inondations. Quelle combinaison de données est la plus pertinente pour commencer ?',
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
    level: 'Avancé',
    icon: Icons.local_hospital_outlined,
    options: [
      'Une carte des noms de quartiers seulement',
      'Des temps de parcours calculés sur le réseau routier et croisés avec la population',
      'Une photographie de chaque centre',
      'Le nombre de routes dans tout le pays',
    ],
    correctIndex: 1,
    explanation:
        'L’accessibilité dépend des déplacements réels. Le réseau routier, les temps de parcours et la population desservie apportent une réponse opérationnelle.',
  ),
];
