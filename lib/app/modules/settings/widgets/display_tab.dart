import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sreyastha_gps/app/modules/settings/controllers/settings_controller.dart';

class DisplayTab extends GetView<SettingsController> {
  const DisplayTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Display settings"),
    );
  }
}
