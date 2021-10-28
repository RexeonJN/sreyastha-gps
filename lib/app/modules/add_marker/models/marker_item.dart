import 'package:flutter_map/plugin_api.dart';

import 'package:sreyastha_gps/app/data/enums/marker_input_type.dart';
import 'package:sreyastha_gps/app/data/models/latlng_data.dart';

class MarkerItem {
  final int id;
  String name;
  Marker marker;
  final LatlngData location;
  String? description;
  final MarkerType markerType;

  MarkerItem({
    required this.id,
    required this.name,
    required this.marker,
    required this.location,
    required this.markerType,
    this.description,
  });

  ///the attributes are converted to list and not into dictionary
  ///because the list of list is used by csv reader to generate a csv file
  List<dynamic> get listOfAttributes => [
        this.id,
        this.name,
        this.location.location.latitude,
        this.location.location.longitude,
        this.location.altitude != null ? this.location.altitude : "",
        this.location.timestamp.toString(),
        this.description != null ? this.description : "Not yet entered",
        asStrings(this.markerType),
      ];
}
