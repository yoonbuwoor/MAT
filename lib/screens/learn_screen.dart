import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../data/software_data.dart';
import '../models/app_models.dart';
import '../widgets/brand_widgets.dart';
import 'glossary_screen.dart';
import 'software_catalog_screen.dart';
import 'topic_detail_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _category = 'Toutes';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = <String>{
      'Toutes',
      for (final topic in learningTopics) topic.category,
    }.toList();
    final query = _query.trim().toLowerCase();
    final topics = learningTopics.where((topic) {
      final categoryMatches =
          _category == 'Toutes' || topic.category == _category;
      final text = '${topic.title} ${topic.subtitle} ${topic.category} '
              '${topic.definition}'
          .toLowerCase();
      return categoryMatches && (query.isEmpty || text.contains(query));
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 122),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const ScreenHeader(
                eyebrow: 'Cours de géomatique',
                title: 'Comprendre, pratiquer, maîtriser',
                subtitle:
                    'Des cours courts mais solides, du système de coordonnées au Web SIG, en passant par le terrain, la télédétection, le LiDAR et la photogrammétrie.',
              ),
              const SizedBox(height: 22),
              const PurposePanel(
                icon: Icons.auto_stories_rounded,
                title: 'Comment utiliser les cours ?',
                description:
                    'Recherche une notion, lis l’exemple, repère l’erreur fréquente puis valide la fiche avant de tester tes connaissances dans les quiz.',
                steps: ['Lire', 'Relier à un cas', 'Valider'],
                color: AppTheme.purple,
              ),
              const SizedBox(height: 24),
              _SoftwareDoor(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SoftwareCatalogScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  labelText: 'Rechercher dans les cours',
                  hintText: 'Ex. GNSS, PostGIS, inondation, LiDAR…',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Effacer',
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ChoiceChip(
                      label: Text(category),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SectionTitle(
                title: '${topics.length} cours affiché(s)',
                subtitle:
                    '${learningTopics.length} cours au total • lecture guidée • exemples professionnels.',
                trailing: TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GlossaryScreen()),
                  ),
                  icon: const Icon(Icons.sort_by_alpha_rounded, size: 18),
                  label: const Text('Glossaire'),
                ),
              ),
              const SizedBox(height: 14),
              if (topics.isEmpty)
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    'Aucun cours ne correspond à cette recherche.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ...topics.map(
                (topic) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TopicCard(
                    topic: topic,
                    isDone:
                        widget.controller.completedTopics.contains(topic.id),
                    isFavorite:
                        widget.controller.favoriteTopics.contains(topic.id),
                    onFavorite: () =>
                        widget.controller.toggleFavorite(topic.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TopicDetailScreen(
                          controller: widget.controller,
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

class _SoftwareDoor extends StatelessWidget {
  const _SoftwareDoor({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Row(
            children: [
              const SoftIcon(
                icon: Icons.apps_rounded,
                color: AppTheme.coral,
                size: 58,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Logiciels de géomatique',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${geomaticsSoftware.length} outils expliqués : utilité, licence, plateformes et meilleur usage.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
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
