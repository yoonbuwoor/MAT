import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../models/app_models.dart';
import '../widgets/brand_widgets.dart';
import 'glossary_screen.dart';
import 'topic_detail_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String query = '';
  String category = 'Tout';

  @override
  Widget build(BuildContext context) {
    final categories = ['Tout', ...{for (final item in learningTopics) item.category}];
    final filtered = learningTopics.where((topic) {
      final matchesQuery = topic.title.toLowerCase().contains(query.toLowerCase()) ||
          topic.subtitle.toLowerCase().contains(query.toLowerCase());
      final matchesCategory = category == 'Tout' || topic.category == category;
      return matchesQuery && matchesCategory;
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SectionTitle(
                title: 'Comprendre',
                subtitle: 'Des fiches courtes pour maîtriser les idées essentielles.',
              ),
              const SizedBox(height: 18),
              TextField(
                onChanged: (value) => setState(() => query = value),
                decoration: const InputDecoration(
                  hintText: 'Rechercher une notion…',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return ChoiceChip(
                      selected: category == item,
                      label: Text(item),
                      onSelected: (_) => setState(() => category = item),
                    );
                  },
                ),
              ),
              const SizedBox(height: 22),
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GlossaryScreen()),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        SoftIcon(
                          icon: Icons.sort_by_alpha_rounded,
                          color: AppTheme.purple,
                          size: 54,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Glossaire géomatique',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                              ),
                              SizedBox(height: 4),
                              Text('Retrouver rapidement les mots techniques.'),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SectionTitle(
                title: 'Fiches de poche',
                subtitle: '${filtered.length} notion${filtered.length > 1 ? 's' : ''} disponible${filtered.length > 1 ? 's' : ''}',
              ),
              const SizedBox(height: 14),
              ...filtered.map((topic) => _TopicCard(
                    topic: topic,
                    controller: widget.controller,
                  )),
              if (filtered.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('Aucune fiche ne correspond à cette recherche.')),
                ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.topic, required this.controller});

  final LearningTopic topic;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final done = controller.completedTopics.contains(topic.id);
    final favorite = controller.favoriteTopics.contains(topic.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TopicDetailScreen(controller: controller, topic: topic),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SoftIcon(icon: topic.icon, color: topic.color, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.category.toUpperCase(),
                        style: TextStyle(
                          color: topic.color,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: .8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        topic.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        topic.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      tooltip: favorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                      onPressed: () => controller.toggleFavorite(topic.id),
                      icon: Icon(favorite ? Icons.bookmark : Icons.bookmark_border),
                      color: favorite ? AppTheme.coral : null,
                    ),
                    if (done) const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
