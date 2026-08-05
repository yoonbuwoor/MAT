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
    required this.level,
    required this.icon,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String title;
  final String scenario;
  final String level;
  final IconData icon;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class ProjectTemplate {
  const ProjectTemplate({
    required this.title,
    required this.description,
    required this.icon,
    required this.steps,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<String> steps;
}

class FieldObservation {
  const FieldObservation({
    required this.name,
    required this.category,
    required this.note,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  final String name;
  final String category;
  final String note;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
}
