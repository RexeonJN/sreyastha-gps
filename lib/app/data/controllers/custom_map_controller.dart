import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';

class CustomMapController extends GetxController {
  static CustomMapController instance = Get.find();
  MapController mapController = MapController();
  //variable to show the distance in the horizontal distance bar
  Rx<double> _longitudinalDistanceShown = Rx<double>(0);

  bool _firstLoad =
      true; //to stop changeDistance from calling setState during first build

  void changeDistance() {
    if (_firstLoad) {
      ///this skips the first build so as to prevent error due to build
      _firstLoad = false;

      ///to change the value of longitudinal value from 0 to some value
      ///earlier i used rebuild to again build the home page but
      ///future also works
      Future.delayed(Duration(seconds: 1)).then(
        (_) => _setDistance(),
      );
    } else {
      if (mapController.bounds != null &&
          mapController.bounds!.northEast != null) _setDistance();
      update();
    }
  }

  bool get firstLoad {
    return _firstLoad;
  }

  Rx<double> get longitudinalDistanceShown => _longitudinalDistanceShown;

  void _setDistance() {
    _longitudinalDistanceShown.value = Geolocator.distanceBetween(
      mapController.bounds!.northWest.latitude,
      mapController.bounds!.northWest.longitude,
      mapController.bounds!.northEast!.latitude,
      mapController.bounds!.northEast!.longitude,
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
      mapController.move(LatLng(location.latitude, location.longitude), 16.0);
    }
  }
}
