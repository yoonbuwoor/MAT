import 'package:flutter/material.dart';
import '../models/app_models.dart';

class AppController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  int currentTab = 0;
  int xp = 320;
  int weeklyGoal = 5;
  int weeklyDone = 3;

  final Set<String> completedTopics = <String>{'projection'};
  final Set<String> favoriteTopics = <String>{'buffer'};
  final Set<String> completedMissions = <String>{};
  final List<FieldObservation> observations = <FieldObservation>[];

  void setTab(int value) {
    currentTab = value;
    notifyListeners();
  }

  void toggleTheme(bool dark) {
    themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (!favoriteTopics.add(id)) {
      favoriteTopics.remove(id);
    }
    notifyListeners();
  }

  void completeTopic(String id) {
    if (completedTopics.add(id)) {
      xp += 25;
      weeklyDone = (weeklyDone + 1).clamp(0, weeklyGoal).toInt();
      notifyListeners();
    }
  }

  void completeMission(String id) {
    if (completedMissions.add(id)) {
      xp += 50;
      notifyListeners();
    }
  }

  void rewardProject() {
    xp += 20;
    notifyListeners();
  }

  void addObservation(FieldObservation observation) {
    observations.insert(0, observation);
    xp += 10;
    notifyListeners();
  }

  int get level => 1 + (xp ~/ 250);
  double get weeklyProgress => weeklyGoal == 0 ? 0 : weeklyDone / weeklyGoal;
}
