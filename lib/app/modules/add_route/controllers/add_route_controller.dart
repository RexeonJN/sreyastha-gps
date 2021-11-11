import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/data/controllers/non_getx_controllers/custom_map_controller.dart';
import 'package:sreyastha_gps/app/data/models/latlng_data.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';

class AddRouteController extends GetxController {
  CustomMapController? _customMapController;
  @override
  void onInit() {
    super.onInit();

    //start getting location from locationController
    startTracking();
    _customMapController = CustomMapController(toUpdateUI: update);
    Future.delayed(Duration(seconds: 1)).then((value) {
      for (MarkerItem itemToTransfer
          in storageController.markerList.markerListAsMarkerItem.value) {
        storageController.routeItem.pointsInMap.value.add(itemToTransfer);
      }
      storageController.updateUI!();
      Get.dialog(
        AlertDialog(
          content: Text(
            "All the markers in your save location page will be shown here. If you load another region then those markers will be shown instead",
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Continue"))
          ],
        ),
      );
    });
  }

  ///provides the list of points which are required to plot a polyline
  Rx<List<LatLng>> providePolylinePointsList() {
    return storageController.routeItem.lineInRoute;
  }

  ///this provides all the markers available in the region
  Rx<List<Marker>> provideAvailableRouteMarkerList() {
    return storageController.routeItem.availableMarkers;
  }

  ///provides the status of whether the route is being created or not
  Rx<bool> provideCreation() {
    return storageController.routeItem.creating;
  }

  ///provides the distance covered
  Rx<double> totalDistance() {
    return storageController.routeItem.totalDistance;
  }

  ///a function to perform the CRUD and all other operation related to
  ///selected routes
  ///
  ///mode:it chooses which operation to perform
  ///
  dynamic operateOnRoute(
    String mode,
  ) {
    switch (mode) {
      case "startRoute":
        storageController.routeItem.startCreating();
        break;
      case "endRoute":
        storageController.routeItem.stopCreating();
        break;
      case "deleteRoute":
        storageController.routeItem.deleteRouteItem();
        break;
      case "undoLastLine":
        storageController.routeItem.undoLastLine();
    }
  }

  ///below the code is same as what is present in add marker
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
