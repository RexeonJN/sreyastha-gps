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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        ///until the controller is defined or the value of current location
        ///is available a circular progress indicator is shown
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
