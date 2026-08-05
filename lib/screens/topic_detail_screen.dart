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
            onPressed: () => controller.toggleFavorite(topic.id),
            icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: topic.color.withOpacity(.11),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoftIcon(icon: topic.icon, color: topic.color, size: 62),
                const SizedBox(height: 18),
                Text(
                  topic.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                Text(topic.subtitle),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _DetailBlock(
            icon: Icons.menu_book_outlined,
            title: 'À retenir',
            child: Text(topic.definition),
          ),
          _DetailBlock(
            icon: Icons.place_outlined,
            title: 'Exemple concret',
            child: Text(topic.example),
          ),
          _DetailBlock(
            icon: Icons.warning_amber_rounded,
            title: 'Erreur fréquente',
            child: Text(topic.frequentError),
          ),
          _DetailBlock(
            icon: Icons.lightbulb_outline,
            title: 'Conseil professionnel',
            child: Text(topic.proTip),
          ),
          _DetailBlock(
            icon: Icons.checklist_rounded,
            title: 'Points essentiels',
            child: Column(
              children: topic.keyPoints
                  .map((point) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            const SizedBox(width: 10),
                            Expanded(child: Text(point)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isDone
                  ? null
                  : () {
                      controller.completeTopic(topic.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fiche validée : +25 XP')),
                      );
                    },
              icon: Icon(isDone ? Icons.check : Icons.task_alt),
              label: Text(isDone ? 'Fiche déjà maîtrisée' : 'Marquer comme maîtrisée'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({required this.icon, required this.title, required this.child});

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppTheme.coral),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
