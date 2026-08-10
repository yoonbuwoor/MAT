import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/brand_widgets.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confidentialité')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
        children: const [
          ScreenHeader(
            eyebrow: 'Moi, Géomaticien',
            title: 'Tes données restent sous ton contrôle',
            subtitle:
                'Politique applicable à la version 4.0 • mise à jour le 10 août 2026.',
          ),
          SizedBox(height: 20),
          _PrivacyBlock(
            icon: Icons.my_location_rounded,
            color: AppTheme.teal,
            title: 'Localisation',
            text:
                'La position précise est utilisée uniquement lorsque l’application est ouverte et que tu lances une mesure. Elle sert à afficher les coordonnées et à créer les points que tu demandes. Aucune localisation en arrière-plan n’est utilisée.',
          ),
          _PrivacyBlock(
            icon: Icons.folder_open_rounded,
            color: AppTheme.coral,
            title: 'Fichiers CSV',
            text:
                'Android te laisse choisir précisément le CSV à importer. Moi, Géomaticien lit uniquement ce fichier pour créer des points et n’explore pas le reste du stockage.',
          ),
          _PrivacyBlock(
            icon: Icons.phonelink_lock_rounded,
            color: AppTheme.purple,
            title: 'Stockage et transmission',
            text:
                'Les points, attributs et progressions sont conservés localement sur le téléphone. L’application ne possède ni compte, ni publicité, ni outil d’analyse, et ne transmet pas ces données à Novateur221 ou à un tiers.',
          ),
          _PrivacyBlock(
            icon: Icons.delete_outline_rounded,
            color: AppTheme.orange,
            title: 'Suppression et partage',
            text:
                'Tu peux supprimer un point ou tous les points dans le module de relevé. Tu décides aussi de l’application destinataire lorsque tu exportes et partages un CSV.',
          ),
          _PrivacyBlock(
            icon: Icons.mail_outline_rounded,
            color: AppTheme.teal,
            title: 'Responsable et contact',
            text:
                'Moi, Géomaticien est éditée par Novateur221. Pour une question sur la confidentialité : novateur221@gmail.com.',
          ),
        ],
      ),
    );
  }
}

class _PrivacyBlock extends StatelessWidget {
  const _PrivacyBlock({
    required this.icon,
    required this.color,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SoftIcon(icon: icon, color: color),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 7),
                    Text(text, style: const TextStyle(height: 1.5)),
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
