import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../data/app_data.dart';
import '../widgets/brand_widgets.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final entries = glossary.entries.where((entry) {
      final q = query.trim().toLowerCase();
      return q.isEmpty ||
          entry.key.toLowerCase().contains(q) ||
          entry.value.toLowerCase().contains(q);
    }).toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      appBar: AppBar(title: const Text('Glossaire géomatique')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
        children: [
          const PurposePanel(
            icon: Icons.sort_by_alpha_rounded,
            title: 'À quoi sert le glossaire ?',
            description:
                'À retrouver le sens d’un terme technique en quelques secondes. Pour une explication complète, ouvre ensuite une fiche du livre de poche.',
            color: AppTheme.purple,
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              hintText: 'Rechercher un terme…',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${entries.length} terme(s)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (entries.isEmpty)
            const EmptyStateCard(
              icon: Icons.search_off_rounded,
              title: 'Aucun terme trouvé',
              message: 'Essaie un autre mot ou une partie du terme.',
            )
          else
            ...entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 5,
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    leading: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.coral.withOpacity(.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        entry.key.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.coral,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    title: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(entry.value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
