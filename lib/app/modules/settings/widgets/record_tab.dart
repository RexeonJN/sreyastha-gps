import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sreyastha_gps/app/modules/settings/controllers/settings_controller.dart';

///TODO: following things to be incorporated into record tab
///1. Record profile
///types- precise, general, power saving and so on
///show data like frequency of location data, accuracy, min distance, max dist
///If accuracy is lower then the point is excluded
///2.corrections to be added to the locations taken(to be added to premium)
///3.default marker name
///4. change the interval time for time and distance

class RecordTab extends GetView<SettingsController> {
  const RecordTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Record settings"),
    );
  }
}
