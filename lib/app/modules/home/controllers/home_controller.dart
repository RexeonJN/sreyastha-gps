import 'package:geolocator/geolocator.dart' show LocationAccuracy;
import 'package:get/get.dart';

import '/app/core/constants/controllers.dart';
import '/app/data/models/latlng_data.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    //start getting location from locationController
    startTracking();
  }

  void startTracking() async {
    if (await locationController.requestPermissions()) {
      locationController.subscribePosition(LocationAccuracy.best);
    }
  }

  Rx<LatlngData?> get currentLocation {
    //all the data of location Controller will be received in this controller
    return locationController.currentLocation;
  }

  ///this is to keep views free from global controllers
  void moveToCurrentLocation() {
    customMapController.moveToCurrentLocation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    //dispose the controller as it will again be created for other controllers
    locationController.unsubscribePosition();
  }
}
