import 'package:sreyastha_gps/app/data/enums/marker_input_type.dart';
import 'package:sreyastha_gps/app/data/models/latlng_data.dart';

///this model will only hold those points which will be use to create route
class RoutePoint {
  ///id to track items in the list of route item. It will be different from the
  ///marker id in the markerlist
  final int id;

  ///rest all information will be taken from the marker item in the markerlist
  String name;

  final LatlngData location;
  final MarkerType markerType;

  RoutePoint({
    required this.id,
    required this.name,
    required this.location,
    required this.markerType,
  });
}
