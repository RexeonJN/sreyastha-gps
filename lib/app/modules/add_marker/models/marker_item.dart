import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MarkerItem {
  final int id;
  String name;
  final Marker marker;
  final LatLng location;

  MarkerItem({
    required this.id,
    required this.name,
    required this.marker,
    required this.location,
  });
}
