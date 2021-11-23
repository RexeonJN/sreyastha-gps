import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:sreyastha_gps/app/data/enums/marker_input_type.dart';
import 'package:sreyastha_gps/app/global_widgets/map_widgets/move_to_current_location_button.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';

import 'package:sreyastha_gps/app/modules/add_marker/widgets/load_region_button.dart';

import 'package:sreyastha_gps/app/modules/add_marker/widgets/marker_page_heading.dart';
import 'package:sreyastha_gps/app/modules/add_marker/widgets/save_region_button.dart';

import '/app/global_widgets/map_container.dart';
import '../controllers/add_marker_controller.dart';

class AddMarkerView extends GetView<AddMarkerController> {
  ///to make the marker location more accurate we start and end making it accurate
  final Rx<bool> _currentlyMarking = false.obs;

  ///this is the average latlng which is plotted after the markers end
  ///tracking
  final Rx<LatLng> averageLatLng = LatLng(25.24, 86.98).obs;
  final Rx<int> numberOfPoints = 0.obs;

  void currentlyMarkingSet(bool value) {
    _currentlyMarking.value = value;
    if (value) {
      averageLatLng.value = controller.currentLocation.value!.location;
      numberOfPoints.value = 1;
    }
  }

  bool currentlyMarkingGet() => _currentlyMarking.value;

  void updateAverageLocation(LatLng value) {
    final _oldAvgLatitude = averageLatLng.value.latitude;
    final _newLatitude = value.latitude;
    final _newAvgLatitude =
        ((_oldAvgLatitude * numberOfPoints.value) + _newLatitude) /
            (numberOfPoints.value + 1);
    final _oldAvgLongitude = averageLatLng.value.longitude;
    final _newLongitude = value.longitude;
    final _newAvgLongitude =
        ((_oldAvgLongitude * numberOfPoints.value) + _newLongitude) /
            (numberOfPoints.value + 1);
    averageLatLng.value = LatLng(_newAvgLatitude, _newAvgLongitude);
  }

  LatLng getAverageLocation() => averageLatLng.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        ///until the controller is defined or the value of current location
        ///is available a circular progress indicator is shown
        ///
        ///TODO:add a button which will only be shown if you login
        () => controller.currentLocation.value != null
            ? Stack(
                children: [
                  MapContainer(
                    controller,
                    markerList: controller.provideMarkerList,
                    operateOnMarker: (String mode,
                        {LatLng? markerPoint,
                        Function? onTapped,
                        MarkerItem? markerItem,
                        MarkerType? markerType,
                        double? altitude,
                        double? accuracy}) {
                      controller.operateOnMarker(mode,
                          markerPoint: markerPoint,
                          onTapped: onTapped,
                          markerType: markerType,
                          altitude: altitude,
                          accuracy: accuracy);
                    },
                    getSelectedMarker: controller.getSelectedMarkerItem,
                    routeType: "Markers",
                    currentlyMarkingGetter: currentlyMarkingGet,
                    currentlyMarkingSetter: currentlyMarkingSet,
                    getAverageLocation: getAverageLocation,
                    updateAverageLocation: updateAverageLocation,
                  ),
                  MarkerPageHeading(),
                  MovetoCurrentLocationButton(controller: controller),
                  SaveRegionButton(),
                  LoadRegionButton(),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
