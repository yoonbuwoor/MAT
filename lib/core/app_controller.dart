import 'dart:async';
import 'package:flutter/material.dart';
import '../models/geo_models.dart';
import '../services/point_storage.dart';

class AppController extends ChangeNotifier {
  AppController() {
    unawaited(_loadGeoPoints());
  }

  final PointStorage _pointStorage = PointStorage();

  ThemeMode themeMode = ThemeMode.light;
  int currentTab = 0;

  // L'application démarre volontairement à zéro.
  int xp = 0;
  int weeklyGoal = 3;
  int weeklyDone = 0;

  final Set<String> completedTopics = <String>{};
  final Set<String> favoriteTopics = <String>{};
  final Set<String> completedMissions = <String>{};

  List<CapturedPoint> geoPoints = <CapturedPoint>[];
  bool geoPointsLoading = true;
  bool _disposed = false;

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

  Future<void> addGeoPoint(CapturedPoint point) async {
    geoPoints = <CapturedPoint>[point, ...geoPoints];
    notifyListeners();
    await _pointStorage.savePoints(geoPoints);
  }

  Future<void> deleteGeoPoint(String id) async {
    geoPoints = geoPoints.where((point) => point.id != id).toList();
    notifyListeners();
    await _pointStorage.savePoints(geoPoints);
  }

  Future<void> clearGeoPoints() async {
    geoPoints = <CapturedPoint>[];
    notifyListeners();
    await _pointStorage.savePoints(geoPoints);
  }

  Future<String> exportGeoPoints() => _pointStorage.exportCsv(geoPoints);

  void resetProgress() {
    xp = 0;
    weeklyDone = 0;
    currentTab = 0;
    completedTopics.clear();
    favoriteTopics.clear();
    completedMissions.clear();
    notifyListeners();
  }

  int get level => 1 + (xp ~/ 250);
  double get weeklyProgress => weeklyGoal == 0 ? 0 : weeklyDone / weeklyGoal;

  Future<void> _loadGeoPoints() async {
    try {
      geoPoints = await _pointStorage.loadPoints();
    } finally {
      geoPointsLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
