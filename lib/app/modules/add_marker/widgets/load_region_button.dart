import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

class LoadRegionButton extends StatelessWidget {
  const LoadRegionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      right: 20,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text(
                      "All the markers in your current region will be lost if they are not saved. If you want to load the new region and override the currrent region then continue or else cancel."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.toNamed(Routes.SAVED, arguments: 0);
                      },
                      child: Text("Okay"),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: light,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(1, 1),
                        color: Colors.grey)
                  ]),
              child: Row(
                children: [
                  Text(
                    "load region",
                    style: TextStyle(
                      color: active,
                    ),
                    textScaleFactor: 1.1,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
