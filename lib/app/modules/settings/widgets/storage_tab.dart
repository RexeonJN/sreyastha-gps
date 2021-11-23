import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sreyastha_gps/app/modules/settings/controllers/settings_controller.dart';

///TODO: following things to be incorporated into the storage tab
///1. Erase application content - Remove all trips stored in the application.
///Action cannot be undone.
///2.Storage statistics - number of trips and markers stored
///3.Maps import folder

class StorageTab extends GetView<SettingsController> {
  const StorageTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Storage settings"),
    );
  }
}
