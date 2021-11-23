import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sreyastha_gps/app/global_widgets/static_content.dart';
import 'package:sreyastha_gps/app/global_widgets/static_page_heading.dart';

import '../controllers/about_controller.dart';

import 'package:flutter/services.dart' as jsonLoadingService;

class AboutView extends GetView<AboutController> {
  ///to get the data from a local json files stored in the assets
  Future<List<dynamic>> readFromJsonData() async {
    final jsonData = await jsonLoadingService.rootBundle
        .loadString("assets/json_files/about_us.json");

    return json.decode(jsonData) as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StaticPageHeading(headingName: "About us"),
          _content(context),
        ],
      ),
    );
  }

  ///content is obtained from the json file and is shown using this widget
  Widget _content(BuildContext context) {
    return StaticContent(
      readData: readFromJsonData,
    );
  }
}
