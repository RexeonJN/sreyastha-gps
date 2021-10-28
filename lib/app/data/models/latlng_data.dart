import 'package:latlong2/latlong.dart';

class LatlngData {
  final LatLng location;
  double? accuracy;
  double? altitude;
  double? speed;
  double? speedAccuracy;
  double? heading;
  final DateTime timestamp;

  LatlngData({
    required this.location,
    this.accuracy,
    this.altitude,
    this.speed,
    this.speedAccuracy,
    this.heading,
    required this.timestamp,
  });
}
