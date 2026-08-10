import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../models/app_models.dart';
import '../widgets/brand_widgets.dart';
import 'practice_detail_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _level = 'Tous';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = widget.controller.completedMissions.length;
    final total = practiceMissions.length;
    final query = _query.trim().toLowerCase();
    final missions = practiceMissions.where((mission) {
      final levelMatches = _level == 'Tous' || mission.level == _level;
      final text = '${mission.title} ${mission.scenario} ${mission.category}'
          .toLowerCase();
      return levelMatches && (query.isEmpty || text.contains(query));
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 122),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const ScreenHeader(
                eyebrow: 'Quiz de géomatique',
                title: 'Tester ton raisonnement professionnel',
                subtitle:
                    'Chaque question part d’une situation réelle : choisis une méthode, valide puis lis la correction expliquée.',
              ),
              const SizedBox(height: 22),
              const PurposePanel(
                icon: Icons.task_alt_rounded,
                title: 'À quoi servent les quiz ?',
                description:
                    'À vérifier les acquis des cours : quelles données utiliser, quel traitement choisir et comment contrôler le résultat.',
                steps: ['Lire le cas', 'Choisir', 'Comprendre la correction'],
                color: AppTheme.teal,
              ),
              const SizedBox(height: 22),
              _ProgressCard(done: done, total: total),
              const SizedBox(height: 28),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  labelText: 'Rechercher un quiz',
                  hintText: 'Ex. projection, NDVI, terrain, PostGIS…',
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
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    const levels = [
                      'Tous',
                      'Débutant',
                      'Intermédiaire',
                      'Avancé',
                    ];
                    final level = levels[index];
                    return ChoiceChip(
                      label: Text(level),
                      selected: _level == level,
                      onSelected: (_) => setState(() => _level = level),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SectionTitle(
                title: '${missions.length} quiz affiché(s)',
                subtitle:
                    '$total questions au total • débutant, intermédiaire et avancé.',
              ),
              const SizedBox(height: 14),
              if (missions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    'Aucun quiz ne correspond à cette recherche.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ...missions.map(
                (mission) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _MissionCard(
                    mission: mission,
                    isDone:
                        widget.controller.completedMissions.contains(mission.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PracticeDetailScreen(
                          controller: widget.controller,
                          mission: mission,
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

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 7,
                  backgroundColor: Colors.white.withOpacity(.11),
                  color: AppTheme.orange,
                ),
                Text(
                  '$done/$total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  done == 0 ? 'Aucun quiz terminé' : '$done quiz terminé(s)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  done == 0
                      ? 'Ton score démarre à zéro. Le premier quiz réussi rapporte 50 XP.'
                      : 'Chaque correction validée renforce ton profil de compétences.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.68),
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.mission,
    required this.isDone,
    required this.onTap,
  });

  final PracticeMission mission;
  final bool isDone;
  final VoidCallback onTap;

  Color _levelColor() {
    switch (mission.level) {
      case 'Débutant':
        return AppTheme.teal;
      case 'Intermédiaire':
        return AppTheme.orange;
      default:
        return AppTheme.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _levelColor();
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 86,
                decoration: BoxDecoration(
                  color: levelColor.withOpacity(.11),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(mission.icon, color: levelColor, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: levelColor.withOpacity(.10),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            mission.level,
                            style: TextStyle(
                              color: levelColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isDone)
                          const Icon(
                            Icons.verified_rounded,
                            color: AppTheme.teal,
                            size: 19,
                          ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      mission.category.toUpperCase(),
                      style: TextStyle(
                        color: levelColor,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .7,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      mission.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '1 question • 4 choix • correction expliquée',
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
