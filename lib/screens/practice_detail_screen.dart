import 'package:flutter/material.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../models/app_models.dart';

class PracticeDetailScreen extends StatefulWidget {
  const PracticeDetailScreen({
    super.key,
    required this.controller,
    required this.mission,
  });

  final AppController controller;
  final PracticeMission mission;

  @override
  State<PracticeDetailScreen> createState() => _PracticeDetailScreenState();
}

class _PracticeDetailScreenState extends State<PracticeDetailScreen> {
  int? selectedIndex;
  bool checked = false;

  bool get isCorrect => selectedIndex == widget.mission.correctIndex;

  @override
  Widget build(BuildContext context) {
    final alreadyDone = widget.controller.completedMissions.contains(widget.mission.id);
    return Scaffold(
      appBar: AppBar(title: Text('Quiz • ${widget.mission.level}')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(widget.mission.icon, color: Colors.white, size: 38),
                const SizedBox(height: 16),
                Text(
                  widget.mission.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.mission.scenario,
                  style: TextStyle(color: Colors.white.withOpacity(.92), height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Quelle est la meilleure réponse ?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 12),
          ...List.generate(widget.mission.options.length, (index) {
            final selected = selectedIndex == index;
            Color? borderColor;
            Color? backgroundColor;
            IconData? resultIcon;

            if (checked && index == widget.mission.correctIndex) {
              borderColor = Colors.green;
              backgroundColor = Colors.green.withOpacity(.08);
              resultIcon = Icons.check_circle;
            } else if (checked && selected && !isCorrect) {
              borderColor = Colors.red;
              backgroundColor = Colors.red.withOpacity(.07);
              resultIcon = Icons.cancel;
            } else if (selected) {
              borderColor = AppTheme.coral;
              backgroundColor = AppTheme.coral.withOpacity(.08);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: checked ? null : () => setState(() => selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: borderColor ?? Theme.of(context).dividerColor.withOpacity(.15),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: selected
                            ? AppTheme.coral
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        foregroundColor: selected ? Colors.white : null,
                        child: Text(
                          String.fromCharCode(65 + index),
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(widget.mission.options[index])),
                      if (resultIcon != null)
                        Icon(resultIcon, color: resultIcon == Icons.check_circle ? Colors.green : Colors.red),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          if (!checked)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: selectedIndex == null
                    ? null
                    : () {
                        setState(() => checked = true);
                        if (isCorrect && !alreadyDone) {
                          widget.controller.completeMission(widget.mission.id);
                        }
                      },
                child: const Text('Valider ma décision'),
              ),
            ),
          if (checked) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.withOpacity(.09) : Colors.orange.withOpacity(.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.verified : Icons.school_outlined,
                        color: isCorrect ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isCorrect ? 'Bonne décision !' : 'Voici la logique attendue',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(widget.mission.explanation),
                  if (isCorrect && !alreadyDone) ...[
                    const SizedBox(height: 10),
                    const Text('+50 XP', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w900)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Retour aux quiz'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
