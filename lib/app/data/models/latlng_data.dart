import 'package:latlong2/latlong.dart';

class LatlngData {
  final LatLng location;
  final double accuracy;
  final double altitude;
  final double speed;
  final double speedAccuracy;
  final double heading;
  final DateTime? timestamp;

  LatlngData({
    required this.location,
    required this.accuracy,
    required this.altitude,
    required this.speed,
    required this.speedAccuracy,
    required this.heading,
    required this.timestamp,
  });
}
