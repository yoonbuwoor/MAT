import 'package:flutter/material.dart';

class LearningTopic {
  const LearningTopic({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
    required this.definition,
    required this.example,
    required this.frequentError,
    required this.proTip,
    required this.keyPoints,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color color;
  final String definition;
  final String example;
  final String frequentError;
  final String proTip;
  final List<String> keyPoints;
}

class PracticeMission {
  const PracticeMission({
    required this.id,
    required this.title,
    required this.scenario,
    required this.category,
    required this.level,
    required this.icon,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String title;
  final String scenario;
  final String category;
  final String level;
  final IconData icon;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class GeomaticsSoftware {
  const GeomaticsSoftware({
    required this.name,
    required this.category,
    required this.license,
    required this.platforms,
    required this.utility,
    required this.bestFor,
    required this.icon,
    required this.color,
  });

  final String name;
  final String category;
  final String license;
  final String platforms;
  final String utility;
  final String bestFor;
  final IconData icon;
  final Color color;
}
