import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Center(
          child: controller.currentLocation.value != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.currentLocation.value!.location.toString(),
                    ),
                    Text(
                      "Altitude " +
                          controller.currentLocation.value!.altitude.toString(),
                    ),
                    Text(
                      "Accuracy " +
                          controller.currentLocation.value!.accuracy.toString(),
                    ),
                    Text(
                      "Heading " +
                          controller.currentLocation.value!.heading.toString(),
                    ),
                    Text(
                      "Speed Accuracy " +
                          controller.currentLocation.value!.speedAccuracy
                              .toString(),
                    ),
                    Text(
                      "Speed " +
                          controller.currentLocation.value!.speed.toString(),
                    ),
                    Text(
                      controller.currentLocation.value!.timestamp.toString(),
                    ),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }
}
