import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sreyastha_gps/app/modules/settings/controllers/settings_controller.dart';

class StorageTab extends GetView<SettingsController> {
  const StorageTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Storage settings"),
    );
  }
}
