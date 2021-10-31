import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

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
  List<String> get listOfAttributes => [
        //this.id.toString(), this is not to be given in the csv
        this.name,
        this.location.location.latitude.toStringAsFixed(6),
        this.location.location.longitude.toStringAsFixed(6),
        this.location.altitude != null ? this.location.altitude.toString() : "",
        "${this.location.timestamp.year}-${this.location.timestamp.month}-${this.location.timestamp.day}",
        "${this.location.timestamp.hour}-${this.location.timestamp.minute}-${this.location.timestamp.second}",
        this.description != null ? this.description! : "Nill",
        asStrings(this.markerType),
      ];

  ///convert a row in csv to a markerItem object
  MarkerItem createMarkerItem(List<String> data, int id, Marker marker) {
    final List<String> date = data[4].split('-');
    final List<String> time = data[5].split('-');
    return MarkerItem(
      id: id,
      name: data[0],
      marker: marker,
      location: LatlngData(
        location: LatLng(
          double.parse(data[1]),
          double.parse(data[2]),
        ),
        timestamp: DateTime(
            int.parse(date[0]),
            int.parse(date[1]),
            int.parse(date[2]),
            int.parse(time[0]),
            int.parse(time[1]),
            int.parse(time[2])),
      ),
      markerType: getMarkerType(data[7]),
    );
  }

  List<String> get nameOfAttributes => [
        "Name",
        "Latitude",
        "Longitude",
        "Altitude",
        "Date",
        "Time",
        "Description",
        "Type of Marker",
      ];
}
