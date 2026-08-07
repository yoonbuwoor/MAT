import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../models/app_models.dart';
import '../widgets/brand_widgets.dart';
import 'glossary_screen.dart';
import 'topic_detail_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 122),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const ScreenHeader(
                eyebrow: 'Livre de poche',
                title: 'Une notion, une fiche, une idée claire',
                subtitle:
                    'La bibliothèque est volontairement directe : aucun filtre ni moteur compliqué. Parcours les fiches essentielles dans l’ordre qui te convient.',
              ),
              const SizedBox(height: 22),
              const PurposePanel(
                icon: Icons.auto_stories_rounded,
                title: 'Comment utiliser les fiches ?',
                description:
                    'Ouvre une notion avant un cours, un exercice ou une sortie terrain. Lis l’exemple, repère l’erreur fréquente, puis marque la fiche comme comprise.',
                steps: ['Lire', 'Relier à un cas', 'Valider'],
                color: AppTheme.purple,
              ),
              const SizedBox(height: 24),
              SectionTitle(
                title: '${learningTopics.length} fiches essentielles',
                subtitle: 'Lecture moyenne : moins de trois minutes.',
                trailing: TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GlossaryScreen()),
                  ),
                  icon: const Icon(Icons.sort_by_alpha_rounded, size: 18),
                  label: const Text('Glossaire'),
                ),
              ),
              const SizedBox(height: 14),
              ...learningTopics.map(
                (topic) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TopicCard(
                    topic: topic,
                    isDone: controller.completedTopics.contains(topic.id),
                    isFavorite: controller.favoriteTopics.contains(topic.id),
                    onFavorite: () => controller.toggleFavorite(topic.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TopicDetailScreen(
                          controller: controller,
                          topic: topic,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.isDone,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  final LearningTopic topic;
  final bool isDone;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 78,
                decoration: BoxDecoration(
                  color: topic.color.withOpacity(.11),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(topic.icon, color: topic.color, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            topic.category.toUpperCase(),
                            style: TextStyle(
                              color: topic.color,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        if (isDone)
                          const Icon(Icons.verified_rounded,
                              size: 18, color: AppTheme.teal),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(topic.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 5),
                    Text(
                      topic.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Définition • Exemple • Conseil',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: onFavorite,
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              isFavorite
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              size: 20,
                              color: isFavorite
                                  ? AppTheme.coral
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(.45),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
