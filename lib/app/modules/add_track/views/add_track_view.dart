import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sreyastha_gps/app/global_widgets/map_container.dart';
import 'package:sreyastha_gps/app/global_widgets/map_widgets/move_to_current_location_button.dart';
import 'package:sreyastha_gps/app/modules/add_track/widgets/track_page_heading.dart';

import '../controllers/add_track_controller.dart';

class AddTrackView extends GetView<AddTrackController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapContainer(
            controller,
            routeType: "Track",
          ),
          TrackPageHeading(),
          MovetoCurrentLocationButton(controller: controller),
        ],
      ),
    );
  }
}
