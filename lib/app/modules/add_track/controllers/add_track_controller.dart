import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/core/constants/settings.dart';
import 'package:sreyastha_gps/app/data/controllers/non_getx_controllers/custom_map_controller.dart';
import 'package:sreyastha_gps/app/data/enums/record_profile.dart';
import 'package:sreyastha_gps/app/data/models/latlng_data.dart';
import 'package:sreyastha_gps/app/modules/add_track/models/track_item.dart';

class AddTrackController extends GetxController {
  CustomMapController? _customMapController;
  @override
  void onInit() {
    super.onInit();

    //start getting location from locationController
    startTracking();
    _customMapController = CustomMapController(toUpdateUI: update);
  }

  Rx<List<LatLng>> providePolylinePointsList() {
    return storageController.trackItem.polylinePoints;
  }

  TrackItem provideTrackItem() {
    return storageController.trackItem;
  }

  Rx<bool> provideRecording() {
    return storageController.trackItem.recording;
  }

  ///a function to perform the CRUD and all other operation related to
  ///selected tracks
  ///
  ///mode:it chooses which operation to perform
  ///
  dynamic operateOnTrack(
    String mode,
  ) {
    switch (mode) {
      case "startTrack":
        storageController.trackItem.startTracking(
          locationController.currentLocation.value!,
        );
        break;
      case "endTrack":
        storageController.trackItem.stopTracking();
        break;
      case "updateTrack":
        storageController.trackItem.setValue();
        break;
      case "deleteTrack":
        storageController.trackItem.deleteTrackItem();
        break;
    }
  }

  ///below the code is same as what is present in add marker
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
