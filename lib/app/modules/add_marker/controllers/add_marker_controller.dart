import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart' show LocationAccuracy;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/data/controllers/non_getx_controllers/custom_map_controller.dart';
import 'package:sreyastha_gps/app/data/enums/marker_input_type.dart';
import 'package:sreyastha_gps/app/data/models/latlng_data.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';

class AddMarkerController extends GetxController {
  CustomMapController? _customMapController;

  @override
  void onInit() {
    super.onInit();

    //start getting location from locationController
    startTracking();
    _customMapController = CustomMapController(toUpdateUI: update);
  }

  ///a getter function is used because the markerList is associated with
  ///the controller. If the markerList is directly passed to the map container
  ///then it will be a new instance and will not be connected to the controller.
  Rx<List<Marker>> provideMarkerList() {
    return storageController.markerList.markerList;
  }

  ///get selected marker
  MarkerItem? getSelectedMarkerItem() {
    return storageController.markerList.selectedItemMarker;
  }

  ///a function to perform the CRUD operation with the selected marker
  dynamic operateOnMarker(String mode, LatLng? markerPoint, Function? onTapped,
      MarkerItem? markerItem, MarkerType? markerType) {
    switch (mode) {
      case "create":
        if (markerPoint != null && markerType != null)
          storageController.markerList
              .addMarker(markerPoint, onTapped, markerType);
        break;
      case "read":

        /// data related to selected marker should be handled from here
        if (storageController.markerList.selectedItemMarker != null) {
          print(storageController.markerList.selectedItemMarker!.id);
          print(storageController.markerList.selectedItemMarker!.location);
        }
        break;
      case "update":
        //if (markerItem != null) markerList.updateMarker(markerItem);
        break;
      case "delete":
        storageController.markerList.deleteMarker();
        break;
      case "resetItem":
        storageController.markerList.changeSelectedItem(null);
        break;
    }
  }

  CustomMapController customMapController() => _customMapController!;

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
    _customMapController!.moveToCurrentLocation();
  }

  @override
  void onClose() {
    //dispose the controller as it will again be created for other controllers
    locationController.unsubscribePosition();
  }
}
