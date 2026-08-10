import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../models/app_models.dart';
import '../widgets/brand_widgets.dart';

class TopicDetailScreen extends StatelessWidget {
  const TopicDetailScreen({
    super.key,
    required this.controller,
    required this.topic,
  });

  final AppController controller;
  final LearningTopic topic;

  @override
  Widget build(BuildContext context) {
    final isDone = controller.completedTopics.contains(topic.id);
    final isFavorite = controller.favoriteTopics.contains(topic.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.category),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
            onPressed: () => controller.toggleFavorite(topic.id),
            icon: Icon(
              isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: topic.color.withOpacity(.10),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: topic.color.withOpacity(.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoftIcon(icon: topic.icon, color: topic.color, size: 62),
                const SizedBox(height: 18),
                Text(
                  topic.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(topic.subtitle),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Lecture guidée • environ 3 minutes',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _DetailBlock(
            number: '01',
            icon: Icons.menu_book_outlined,
            title: 'Définition simple',
            helper: 'Commence ici pour comprendre l’idée centrale.',
            child: Text(topic.definition),
          ),
          _DetailBlock(
            number: '02',
            icon: Icons.place_outlined,
            title: 'Exemple concret',
            helper: 'Observe comment la notion s’utilise dans une situation réelle.',
            child: Text(topic.example),
          ),
          _DetailBlock(
            number: '03',
            icon: Icons.warning_amber_rounded,
            title: 'Erreur fréquente',
            helper: 'À vérifier avant de lancer ton traitement.',
            child: Text(topic.frequentError),
          ),
          _DetailBlock(
            number: '04',
            icon: Icons.lightbulb_outline_rounded,
            title: 'Conseil professionnel',
            helper: 'Une bonne pratique à intégrer dans ton workflow.',
            child: Text(topic.proTip),
          ),
          _DetailBlock(
            number: '05',
            icon: Icons.checklist_rounded,
            title: 'Trois points à retenir',
            helper: 'Relis-les avant de marquer la fiche comme maîtrisée.',
            child: Column(
              children: topic.keyPoints
                  .map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.teal,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(point)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isDone
                  ? null
                  : () {
                      controller.completeTopic(topic.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cours validé : +25 XP'),
                        ),
                      );
                    },
              icon: Icon(isDone ? Icons.verified_rounded : Icons.task_alt_rounded),
              label: Text(
                isDone
                    ? 'Ce cours est déjà validé'
                    : 'J’ai compris cette notion',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Valide uniquement après avoir lu les cinq blocs.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({
    required this.number,
    required this.icon,
    required this.title,
    required this.helper,
    required this.child,
  });

  final String number;
  final IconData icon;
  final String title;
  final String helper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SoftIcon(icon: icon, color: AppTheme.coral, size: 44),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$number  $title',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 3),
                        Text(helper, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
