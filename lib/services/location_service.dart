import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationServiceException implements Exception {
  const LocationServiceException(this.message);
  final String message;
  @override
  String toString() => message;
}

class LocationService {
  static Future<LocationPermission> permissionStatus() =>
      Geolocator.checkPermission();

  static Future<LocationPermission> requestPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(
        'L’autorisation de localisation a été refusée.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'La localisation est bloquée pour cette application. Ouvre les paramètres du téléphone pour l’autoriser.',
      );
    }
    return permission;
  }

  static Future<Position> currentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceException(
        'La localisation est désactivée. Active le GPS puis réessaie.',
      );
    }
    await requestPermission();

    const preciseSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 20),
    );
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: preciseSettings,
      );
    } on TimeoutException {
      const fallbackSettings = LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 12),
      );
      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: fallbackSettings,
        );
      } on TimeoutException {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) return lastKnown;
        throw const LocationServiceException(
          'Le GPS ne répond pas. Place-toi à l’extérieur, active la haute précision puis réessaie.',
        );
      }
    }
  }

  static Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
  static Future<bool> openAppSettings() => Geolocator.openAppSettings();
}
