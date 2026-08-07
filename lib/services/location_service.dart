import 'package:geolocator/geolocator.dart';

class LocationServiceException implements Exception {
  const LocationServiceException(this.message);
  final String message;
  @override
  String toString() => message;
}

class LocationService {
  static Future<Position> currentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceException(
        'La localisation est désactivée. Active le GPS puis réessaie.',
      );
    }

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

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 25),
    );
    return Geolocator.getCurrentPosition(locationSettings: settings);
  }

  static Stream<Position> positionStream() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
    );
    return Geolocator.getPositionStream(locationSettings: settings);
  }

  static Future<void> openLocationSettings() => Geolocator.openLocationSettings();
  static Future<void> openAppSettings() => Geolocator.openAppSettings();
}
