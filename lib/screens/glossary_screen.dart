import 'package:flutter/material.dart';
import '../data/app_data.dart';

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
      final search = query.toLowerCase();
      return entry.key.toLowerCase().contains(search) ||
          entry.value.toLowerCase().contains(search);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Glossaire géomatique')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              hintText: 'Rechercher un terme…',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 18),
          ...entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  collapsedBackgroundColor: Theme.of(context).cardColor,
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w900)),
                  children: [Align(alignment: Alignment.centerLeft, child: Text(entry.value))],
                ),
              )),
        ],
      ),
    );
  }
}
