import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/modules/saved/widgets/custom_saved_list.dart';

import '../controllers/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  @override
  Widget build(BuildContext context) {
    ///this changes the index of the tab depending upon what is passed
    /// when navigating
    controller.changeIndex(Get.arguments);
    return DefaultTabController(
      initialIndex: controller.currentIndex.value,
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: light,
            title: Text(
              'Saved Items',
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
              tabs: ["Markers", "Routes", "Track"]
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
              CustomSavedList(),
              Container(),
              Container(),
            ],
          )),
    );
  }
}
