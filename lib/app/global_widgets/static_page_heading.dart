import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class StaticPageHeading extends StatelessWidget {
  const StaticPageHeading({
    Key? key,
    required this.headingName,
  }) : super(key: key);

  final String headingName;

  @override
  Widget build(BuildContext context) {
    final Widget _backButton = Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      width: MediaQuery.of(context).size.width * 0.25,
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
    );
    return Padding(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    headingName,
                    style: GoogleFonts.poppins(color: active),
                    textScaleFactor: 1.4,
                  ),
                ),
                Row(
                  children: [_backButton, Expanded(child: Container())],
                )
              ],
            ),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.0),
    );
  }
}
