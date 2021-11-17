import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/global_widgets/static_page_heading.dart';

import '../controllers/faq_controller.dart';

import 'package:flutter/services.dart' as jsonLoadingService;

///to show the FAQ page
class FaqView extends GetView<FaqController> {
  ///to get the data from a local json files stored in the assets
  Future<List<dynamic>> readFromJsonData() async {
    final jsonData = await jsonLoadingService.rootBundle
        .loadString("assets/json_files/how_to_use.json");

    ///generally the data obtained is of the type List<dynamic>
    return json.decode(jsonData) as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StaticPageHeading(headingName: "FAQs"),
          _content(context),
        ],
      ),
    );
  }

  ///content is obtained from the json file and is shown using this widget
  Widget _content(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: readFromJsonData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            ///in case it is unable to load the local file
            return Text("Error in loading the file");
          } else if (snapshot.hasData) {
            ///converting the object into the data type
            var data = snapshot.data as List<dynamic>;
            return ListView(
              children: data.map((value) {
                var onefaq = value as Map<String, dynamic>;

                ///one faq represent one question and answer
                return Column(
                  children: [
                    ExpandableNotifier(
                      initialExpanded: true,
                      child: Expandable(
                        expanded: ExpandableButton(
                          child: Column(
                            children: [
                              mainCategory(onefaq["question"], context),
                              subCategory(onefaq["answer"], context)
                            ],
                          ),
                        ),
                        collapsed: ExpandableButton(
                          child: mainCategory(onefaq["question"], context),
                        ),
                      ),
                    ),
                    SizedBox(height: 10)
                  ],
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ///container to show question
  Widget mainCategory(String item, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active,
      ),
      child: Text(
        item,
        style: TextStyle(color: light),
        textScaleFactor: 1.2,
      ),
    );
  }

  ///container to show the answer
  Widget subCategory(String item, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: active,
          width: 2,
        ),
      ),
      child: Text(
        item,
        style: TextStyle(color: active),
        textScaleFactor: 1.2,
      ),
    );
  }
}
