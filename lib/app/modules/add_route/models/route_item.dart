import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';
import 'package:sreyastha_gps/app/modules/add_route/models/route_marker_item.dart';

class RouteItem {
  ///there is no need of id or name as the filename can be used either as id or
  ///name

  ///counter to provide an id for the marker
  int _counter = 0;

  ///these points hold points which are available in a region
  Rx<List<MarkerItem>> pointsInMap = Rx<List<MarkerItem>>([]);

  ///Rather than using marker item route marker item is used which doesnt hold
  ///some of the information
  ///the polyline will be tracked using this routemarkeritem
  Rx<List<RoutePoint>> pointInRoute = Rx<List<RoutePoint>>([]);

  ///Routing can only have two states which are either creating or stop
  ///false:not creating and true:creating
  final Rx<bool> _creating = Rx<bool>(false);

  ///get the status of creation
  Rx<bool> get creating => _creating;

  Rx<double> _totalDistance = Rx(0);

  ///starts the route creating process
  void startCreating() {
    _creating.value = true;
  }

  ///a marker item is converted to route point which can then be added to the
  ///route item list
  ///there is no need of converting route point to marker item
  ///this is called while converting markerlist to points in map during
  ///adding points in routeitem
  RoutePoint convertMarkerItemToRoutePoint(MarkerItem markerItem) {
    ///starts counter from 1
    _counter++;
    return RoutePoint(
      id: _counter,
      name: markerItem.name,
      location: markerItem.location,
      markerType: markerItem.markerType,
    );
  }

  ///it keeps on filling the list once the routing has started
  void createNext(RoutePoint routePoint) {
    if (_creating.value) {
      if (pointInRoute.value.length > 0)
        _totalDistance.value += Geolocator.distanceBetween(
            pointInRoute.value.last.location.location.latitude,
            pointInRoute.value.last.location.location.longitude,
            routePoint.location.location.latitude,
            routePoint.location.location.longitude);

      pointInRoute.value.add(routePoint);
    }
  }

  ///undo the last line which is added in the route
  void undoLastLine() {
    try {
      if (pointInRoute.value.length > 0) {
        RoutePoint _tempPoint = pointInRoute.value.last;

        pointInRoute.value.remove(pointInRoute.value.last);
        _totalDistance.value -= Geolocator.distanceBetween(
          _tempPoint.location.location.latitude,
          _tempPoint.location.location.longitude,
          pointInRoute.value.last.location.location.latitude,
          pointInRoute.value.last.location.location.longitude,
        );
      }
    } catch (e) {}
  }

  ///stops the route creating process
  void stopCreating() {
    _creating.value = false;
  }

  Rx<double> get totalDistance =>
      Rx<double>(_totalDistance.value.toPrecision(5));

  ///deletes the route item
  void deleteRouteItem() {
    pointInRoute.value = [];
    _totalDistance.value = 0;
  }

  ///these polypoints will be needed in order to plot the track in the map
  ///however it will not be used during storing the file
  Rx<List<LatLng>> get lineInRoute {
    return Rx(pointInRoute.value
        .map((markerItem) => markerItem.location.location)
        .toList());
  }

  ///get a list of all the markers in the region
  Rx<List<Marker>> get availableMarkers {
    return Rx(pointsInMap.value.map((e) => e.marker).toList());
  }

  ///these are the column names which will be defined in the csv
  List<String> get nameOfAttributes => [
        ///here name is for the name of the marker. the name of route is filename
        "Name",
        "Description",
        "Latitude",
        "Longitude",
        "Accuracy",
        "Altitude",
        "Date",
        "Time",
      ];

  ///function to get the list of all MarkerItem which can be saved
  ///later in csv
  ///these will be converted to one row at a time
  List<List<String>> get routeItemValuesAsList {
    return pointInRoute.value
        .map((oneRow) => valuesOfAttributes(oneRow))
        .toList();
  }

  ///each markerItem data will be converted into a list which is then used by
  /// csv reader to generate a csv file
  List<String> valuesOfAttributes(RoutePoint oneRow) => [
        oneRow.name,
        oneRow.location.location.latitude.toStringAsFixed(6),
        oneRow.location.location.longitude.toStringAsFixed(6),
        oneRow.location.accuracy.toString(),
        oneRow.location.altitude != null
            ? oneRow.location.altitude.toString()
            : "0",
        "${oneRow.location.timestamp.year}-${oneRow.location.timestamp.month}-${oneRow.location.timestamp.day}",
        "${oneRow.location.timestamp.hour}-${oneRow.location.timestamp.minute}-${oneRow.location.timestamp.second}",
      ];

  ///TODO:A function to create route from the list
  ///loading a route will override the markerlist in marker page as well

}
