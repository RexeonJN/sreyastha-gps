import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/global_widgets/static_page_heading.dart';

import '../controllers/contact_us_controller.dart';

class ContactUsView extends GetView<ContactUsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StaticPageHeading(headingName: "Contact Us"),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: active,
              boxShadow: [
                BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(1, 1),
                    color: Colors.grey)
              ],
            ),
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.1,
                    vertical: constraints.maxHeight * 0.1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: {
                      "Phone Number": "9876543210",
                      "Email Address": "sreyastha@gmail.com",
                    }
                        .map(
                          (key, value) => MapEntry(
                            key,
                            profileRow(key, value),
                          ),
                        )
                        .values
                        .toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget profileRow(String item, String itemValue) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Text(
            item,
            textScaleFactor: 1.2,
            style: TextStyle(
              color: light,
            ),
          ),
        ),
        Expanded(child: Container()),
        Flexible(
          child: Text(
            ":",
            style: TextStyle(fontWeight: FontWeight.bold, color: light),
            textScaleFactor: 1.2,
          ),
        ),
        Spacer(),
        Flexible(
          flex: 5,
          child: Text(
            itemValue,
            style: TextStyle(color: light),
            textScaleFactor: 1.2,
          ),
        )
      ],
    );
  }
}
