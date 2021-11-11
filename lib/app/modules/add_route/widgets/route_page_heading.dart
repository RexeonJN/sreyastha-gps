import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

class RoutePageHeading extends StatelessWidget {
  const RoutePageHeading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: light.withOpacity(0.7),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 5),
                        Text("Back"),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Create route",
                    style: GoogleFonts.poppins(color: active),
                    textScaleFactor: 0.9,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                  child: InkWell(
                    onTap: () {
                      ///to maintain all the flow if user decide not to move
                      ///back to route page
                      Get.back();
                      Get.toNamed(Routes.ADD_MARKER);
                    },
                    child: Row(
                      children: [
                        Text("add location"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
          )
        ],
      ),
      padding: EdgeInsets.all(8.0),
    );
  }
}
