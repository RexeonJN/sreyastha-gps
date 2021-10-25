import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

class MarkerPageHeading extends StatelessWidget {
  const MarkerPageHeading({
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                      if (Get.previousRoute == Routes.HOME) Get.back();
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
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Press on the map to create a marker",
                    style: GoogleFonts.poppins(color: active),
                    textScaleFactor: 0.9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.0),
    );
  }
}
