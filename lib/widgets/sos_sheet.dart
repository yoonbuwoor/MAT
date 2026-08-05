import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class SosGeomaticienSheet extends StatefulWidget {
  const SosGeomaticienSheet({super.key});

  @override
  State<SosGeomaticienSheet> createState() => _SosGeomaticienSheetState();
}

class _SosGeomaticienSheetState extends State<SosGeomaticienSheet> {
  String? selectedIssue;

  static const issues = <String, List<String>>{
    'Mes couches ne se superposent pas': [
      'Vérifie le système de coordonnées déclaré pour chaque couche.',
      'Confirme que les coordonnées correspondent réellement à la zone étudiée.',
      'Reprojette les données dans un même système, sans seulement modifier leur étiquette.',
      'Contrôle l’ordre longitude/latitude dans les fichiers CSV.',
    ],
    'Mes distances ou superficies sont fausses': [
      'Vérifie si les données sont encore en latitude/longitude exprimées en degrés.',
      'Choisis un système projeté adapté à la zone et aux unités attendues.',
      'Répare les géométries invalides avant le calcul.',
      'Compare un résultat avec une mesure connue pour valider la méthode.',
    ],
    'Mon fichier CSV ne s’affiche pas': [
      'Repère les colonnes contenant latitude et longitude.',
      'Vérifie le séparateur décimal et le séparateur de colonnes.',
      'Supprime les caractères inutiles dans les coordonnées.',
      'Déclare le bon système de coordonnées lors de l’import.',
    ],
    'Ma carte est difficile à lire': [
      'Définis le message principal de la carte en une phrase.',
      'Réduis le nombre de couleurs et de classes.',
      'Crée une hiérarchie entre information principale et contexte.',
      'Teste la carte en miniature avant l’export final.',
    ],
    'Mon raster apparaît noir ou vide': [
      'Zoome sur l’étendue réelle de la couche.',
      'Calcule les statistiques du raster.',
      'Ajuste les valeurs minimale et maximale de rendu.',
      'Vérifie les valeurs NoData et le système de coordonnées.',
    ],
    'Je ne sais pas quelle projection choisir': [
      'Identifie la localisation et l’étendue exacte du projet.',
      'Détermine si tu dois préserver surtout les surfaces, les distances ou les directions.',
      'Consulte les systèmes officiels ou couramment utilisés dans la zone.',
      'Documente ton choix dans les métadonnées et le rapport.',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.35),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppTheme.coral,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.support_agent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SOS Géomaticien',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const Text('Choisis ton problème pour lancer le diagnostic.'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Flexible(
              child: SingleChildScrollView(
                child: selectedIssue == null
                    ? Column(
                        children: issues.keys.map((issue) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              tileColor: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              leading: const Icon(Icons.error_outline),
                              title: Text(
                                issue,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => setState(() => selectedIssue = issue),
                            ),
                          );
                        }).toList(),
                      )
                    : _buildDiagnostic(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnostic(BuildContext context) {
    final steps = issues[selectedIssue]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => setState(() => selectedIssue = null),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Changer de problème'),
        ),
        const SizedBox(height: 8),
        Text(
          selectedIssue!,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 14),
        ...List.generate(steps.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.coral.withOpacity(.14),
                  foregroundColor: AppTheme.coral,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(steps[index])),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.purple.withOpacity(.10),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, color: AppTheme.purple),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Conserve une copie des données originales avant toute correction importante.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
