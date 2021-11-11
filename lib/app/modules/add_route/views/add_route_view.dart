import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:sreyastha_gps/app/global_widgets/map_container.dart';
import 'package:sreyastha_gps/app/global_widgets/map_widgets/move_to_current_location_button.dart';
import 'package:sreyastha_gps/app/modules/add_route/widgets/route_page_heading.dart';

import '../controllers/add_route_controller.dart';

class AddRouteView extends GetView<AddRouteController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.currentLocation.value != null
            ? Stack(
                children: [
                  MapContainer(
                    controller,
                    routeType: "Route",
                    routeRecording: controller.provideCreation,
                    routeAvailableMarkerList:
                        controller.provideAvailableRouteMarkerList,
                    operateOnRoute: controller.operateOnRoute,
                    routePolylineList: controller.providePolylinePointsList,
                    totalDistanceCovered: controller.totalDistance,
                  ),
                  RoutePageHeading(),
                  MovetoCurrentLocationButton(controller: controller),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
