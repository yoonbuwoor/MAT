import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../widgets/brand_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final dark = controller.themeMode == ThemeMode.dark;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SectionTitle(
                title: 'Moi',
                subtitle: 'Mon identité, mes compétences et mon évolution.',
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.purple, AppTheme.coral],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.purple,
                      child: Icon(Icons.person, size: 42),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Mon passeport géomatique',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Niveau ${controller.level} • ${controller.xp} XP',
                      style: TextStyle(color: Colors.white.withOpacity(.84)),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileStat(
                            value: '${controller.completedTopics.length}',
                            label: 'Fiches maîtrisées',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ProfileStat(
                            value: '${controller.completedMissions.length}',
                            label: 'Missions validées',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const SectionTitle(
                title: 'Compétences',
                subtitle: 'Une première estimation à partir de ton activité.',
              ),
              const SizedBox(height: 14),
              const _SkillCard(),
              const SizedBox(height: 26),
              const SectionTitle(title: 'Badges'),
              const SizedBox(height: 14),
              SizedBox(
                height: 112,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _Badge(icon: Icons.public, title: 'Maître des projections', unlocked: true),
                    _Badge(icon: Icons.map_outlined, title: 'Cartographe débutant', unlocked: true),
                    _Badge(icon: Icons.grid_on_rounded, title: 'Analyste raster', unlocked: false),
                    _Badge(icon: Icons.location_searching, title: 'Explorateur terrain', unlocked: false),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const SectionTitle(title: 'Réglages'),
              const SizedBox(height: 14),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: Icon(dark ? Icons.dark_mode : Icons.light_mode),
                      title: const Text('Mode sombre', style: TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: const Text('Adapter le confort visuel de l’application.'),
                      value: dark,
                      onChanged: controller.toggleTheme,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.download_for_offline_outlined),
                      title: const Text('Contenus hors connexion', style: TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text('${learningTopics.length} fiches intégrées dans l’application'),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: Icon(Icons.language),
                      title: Text('Langue', style: TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text('Français'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const SectionTitle(title: 'À propos'),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/images/novateur221.png',
                              width: 58,
                              height: 58,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Une application Novateur221',
                                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text('Conçue pour accompagner les géomaticiens en formation et en activité.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.coral.withOpacity(.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Moi, Géomaticien — La géomatique dans votre poche.\nVersion 1.0.0',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
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

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(.76), fontSize: 11)),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard();

  @override
  Widget build(BuildContext context) {
    const skills = <String, double>{
      'Cartographie': .75,
      'QGIS et SIG': .68,
      'Analyse spatiale': .54,
      'Télédétection': .40,
      'Bases de données': .30,
      'Programmation': .18,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: skills.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w800))),
                      Text('${(entry.value * 100).round()} %'),
                    ],
                  ),
                  const SizedBox(height: 7),
                  LinearProgressIndicator(value: entry.value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.title, required this.unlocked});

  final IconData icon;
  final String title;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 126,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            unlocked ? icon : Icons.lock_outline,
            color: unlocked ? AppTheme.coral : Colors.grey,
            size: 29,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: unlocked ? null : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
