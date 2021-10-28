import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart' show Geolocator, Position;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';

class CustomMapController {
  Function toUpdateUI;
  CustomMapController({required this.toUpdateUI});

  //variable to show the distance in the horizontal distance bar
  Rx<double> _longitudinalDistanceShown = Rx<double>(0);
  MapController _mapController = MapController();

  bool _firstLoad =
      true; //to stop changeDistance from calling setState during first build

  void changeDistance() {
    if (_firstLoad) {
      ///this skips the first build so as to prevent error due to build
      _firstLoad = false;

      ///to change the value of longitudinal value from 0 to some value
      ///earlier i used rebuild to again build the home page but
      ///future also works
      Future.delayed(Duration(milliseconds: 100)).then(
        (_) {
          _setDistance();
          moveToCurrentLocation();
        },
      );
    } else {
      if (_mapController.bounds != null &&
          _mapController.bounds!.northEast != null) _setDistance();
      toUpdateUI();
    }
  }

  bool get firstLoad {
    return _firstLoad;
  }

  Rx<double> get longitudinalDistanceShown => _longitudinalDistanceShown;

  void _setDistance() {
    _longitudinalDistanceShown.value = Geolocator.distanceBetween(
      _mapController.bounds!.northWest.latitude,
      _mapController.bounds!.northWest.longitude,
      _mapController.bounds!.northEast!.latitude,
      _mapController.bounds!.northEast!.longitude,
    );
  }

  void moveToCurrentLocation() {
    if (!_firstLoad) {
      if (locationController.currentLocation.value != null) {
        moveTheMap(
            location: locationController.currentLocation.value!.location);
      }
    }
  }

  void moveTheMap({LatLng? location}) {
    if (location != null) {
      _mapController.move(LatLng(location.latitude, location.longitude), 16.0);
    }
  }

  MapController get mapController {
    return _mapController;
  }

  ///get the current position from location Controller
  Position? get currentPosition {
    return locationController.currentPosition;
  }

  ///during transition _firstload needs to be set to true
  void setReload() {
    _firstLoad = true;
  }
}
