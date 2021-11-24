import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/modules/settings/widgets/record_tab.dart';
import 'package:sreyastha_gps/app/modules/settings/widgets/storage_tab.dart';

import '../controllers/settings_controller.dart';

///to check the csv accesibility all the file system is checked in settings page
///for now. This needs to be changed after the csv file system is implemented

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    ///this changes the index of the tab depending upon what is passed
    /// when navigating
    controller.changeIndex(Get.arguments);

    return DefaultTabController(
      initialIndex: controller.currentIndex.value,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: light,
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(color: active),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: active,
              ),
            ),
            bottom: TabBar(
              tabs: ["Record", "Storage"]
                  .map((String name) => Tab(
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(color: active),
                        ),
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children: [
              RecordTab(),
              StorageTab(),
            ],
          )),
    );
  }
}
