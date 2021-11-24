import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/constants/settings.dart';
import 'package:sreyastha_gps/app/data/controllers/non_getx_controllers/custom_map_controller.dart';
import 'package:sreyastha_gps/app/data/enums/record_profile.dart';

import '/app/core/constants/controllers.dart';
import '/app/data/models/latlng_data.dart';

class HomeController extends GetxController {
  CustomMapController? _customMapController;
  @override
  void onInit() {
    super.onInit();

    //start getting location from locationController
    startTracking();
    _customMapController = CustomMapController(toUpdateUI: updateUI);
    Future.delayed(Duration(seconds: 1)).then((value) async {
      retrieveSettingsData();
    });
  }

  void updateUI() {
    update();
  }

  CustomMapController customMapController() => _customMapController!;

  void startTracking() async {
    if (await locationController.requestPermissions()) {
      locationController.subscribePosition(getLocationAccuracyFromRecordProfile(
          getRecordProfileFromString(SETTINGS["recordProfile"]!)));
    }
  }

  Rx<LatlngData?> get currentLocation {
    //all the data of location Controller will be received in this controller
    return locationController.currentLocation;
  }

  ///this is to keep views free from global controllers
  void moveToCurrentLocation() {
    _customMapController!.moveToCurrentLocation();
  }

  @override
  void onClose() {
    //dispose the controller as it will again be created for other controllers
    locationController.unsubscribePosition();
  }
}
