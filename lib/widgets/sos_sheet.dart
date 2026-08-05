import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'brand_widgets.dart';

class SosGeomaticienSheet extends StatefulWidget {
  const SosGeomaticienSheet({super.key});

  @override
  State<SosGeomaticienSheet> createState() => _SosGeomaticienSheetState();
}

class _SosGeomaticienSheetState extends State<SosGeomaticienSheet> {
  _Diagnostic? selected;

  static const diagnostics = <_Diagnostic>[
    _Diagnostic(
      icon: Icons.layers_clear_outlined,
      title: 'Mes couches ne se superposent pas',
      summary: 'Vérifier les systèmes de coordonnées et l’ordre des axes.',
      checks: [
        'Ouvre les propriétés de chaque couche et note son système de coordonnées.',
        'Vérifie que les coordonnées correspondent réellement à la zone d’étude.',
        'Ne change pas seulement l’étiquette du SCR : reprojette la couche si nécessaire.',
        'Contrôle l’ordre longitude/latitude lors d’un import CSV.',
      ],
    ),
    _Diagnostic(
      icon: Icons.straighten_outlined,
      title: 'Mes distances ou superficies sont fausses',
      summary: 'Travailler dans un système projeté avec des unités métriques.',
      checks: [
        'Vérifie si la couche est en degrés ou en mètres.',
        'Choisis une projection adaptée à la zone et à l’échelle du travail.',
        'Reprojette la donnée avant de calculer la géométrie.',
        'Compare une mesure connue pour contrôler l’ordre de grandeur.',
      ],
    ),
    _Diagnostic(
      icon: Icons.image_not_supported_outlined,
      title: 'Mon raster est noir ou illisible',
      summary: 'Contrôler l’étendue des valeurs et le mode de rendu.',
      checks: [
        'Calcule ou recharge les statistiques du raster.',
        'Utilise un étirement min–max ou cumulatif adapté.',
        'Vérifie les valeurs NoData et le nombre de bandes.',
        'Contrôle que le raster n’est pas affiché hors de sa zone réelle.',
      ],
    ),
    _Diagnostic(
      icon: Icons.table_chart_outlined,
      title: 'Mon fichier CSV ne crée pas les bons points',
      summary: 'Vérifier séparateur, champs X/Y et format décimal.',
      checks: [
        'Identifie correctement le champ X comme longitude et Y comme latitude.',
        'Vérifie si le séparateur est une virgule, un point-virgule ou une tabulation.',
        'Uniformise le séparateur décimal dans les nombres.',
        'Attribue le système de coordonnées correspondant aux valeurs source.',
      ],
    ),
    _Diagnostic(
      icon: Icons.map_outlined,
      title: 'Ma carte est difficile à lire',
      summary: 'Simplifier le message et reconstruire la hiérarchie visuelle.',
      checks: [
        'Formule en une phrase le message principal de la carte.',
        'Réduis le nombre de couleurs et de classes inutiles.',
        'Mets en retrait les éléments de contexte secondaires.',
        'Teste la carte au format final avant l’export.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: .88,
        minChildSize: .55,
        maxChildSize: .96,
        builder: (context, scrollController) {
          return Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const SoftIcon(
                      icon: Icons.support_agent_rounded,
                      color: AppTheme.coral,
                      size: 54,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SOS Géomaticien',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(
                            'Choisis un symptôme pour obtenir une procédure de vérification.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.orange.withOpacity(.09),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.orange.withOpacity(.18)),
                  ),
                  child: const Text(
                    'Cet outil ne répare pas automatiquement les données. Il t’aide à vérifier les causes les plus courantes dans le bon ordre.',
                    style: TextStyle(fontWeight: FontWeight.w700, height: 1.4),
                  ),
                ),
                const SizedBox(height: 20),
                if (selected == null) ...[
                  Text('Quel est le problème ?',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ...diagnostics.map(
                    (diagnostic) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(15, 8, 12, 8),
                          leading: SoftIcon(
                            icon: diagnostic.icon,
                            color: AppTheme.purple,
                            size: 44,
                          ),
                          title: Text(
                            diagnostic.title,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(diagnostic.summary),
                          ),
                          trailing: const Icon(Icons.arrow_forward_rounded),
                          onTap: () => setState(() => selected = diagnostic),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  TextButton.icon(
                    onPressed: () => setState(() => selected = null),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Choisir un autre problème'),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.ink,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Icon(selected!.icon, color: AppTheme.orange, size: 31),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selected!.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                selected!.summary,
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
                  ),
                  const SizedBox(height: 18),
                  Text('Vérifie dans cet ordre',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  ...List.generate(selected!.checks.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppTheme.coral.withOpacity(.11),
                                foregroundColor: AppTheme.coral,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(selected!.checks[index])),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Diagnostic {
  const _Diagnostic({
    required this.icon,
    required this.title,
    required this.summary,
    required this.checks,
  });

  final IconData icon;
  final String title;
  final String summary;
  final List<String> checks;
}
