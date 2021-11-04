import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sreyastha_gps/app/modules/settings/controllers/settings_controller.dart';

class RecordTab extends GetView<SettingsController> {
  const RecordTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Record settings"),
    );
  }
}
