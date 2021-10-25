import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/global_widgets/map_widgets/move_to_current_location_button.dart';

import 'package:sreyastha_gps/app/modules/add_marker/widgets/marker_page_heading.dart';

import '/app/global_widgets/map_container.dart';
import '../controllers/add_marker_controller.dart';

class AddMarkerView extends GetView<AddMarkerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapContainer(
            controller,
            markerList: controller.provideMarkerList,
            operateOnMarker:
                (String mode, LatLng? markerPoint, Function? onTapped) {
              controller.operateOnMarker(mode, markerPoint, onTapped);
            },
            getSelectedMarker: controller.getSelectedMarkerItem,
          ),
          MarkerPageHeading(),
          MovetoCurrentLocationButton(controller: controller),
        ],
      ),
    );
  }
}
