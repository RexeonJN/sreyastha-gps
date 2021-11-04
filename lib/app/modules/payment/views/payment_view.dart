import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/modules/payment/widgets/subscribe_button.dart';

import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: active,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  Container(
                    child: Text(
                      "Subscribe for premium features",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Improve the accuracy of current location when plotting a marker",
                    softWrap: true,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Get continuous correction from server to improve the accuracy of GPS",
                    softWrap: true,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 40),
                  SubscribeButton(
                    buttonDescriptionText: "INR 20 for a month",
                    buttonText: "Subscribe for a month",
                    executePayment: () =>
                        controller.sendTypeOfPayment("monthly", context),
                  ),
                  SizedBox(height: 40),
                  SubscribeButton(
                    buttonDescriptionText: "INR 200 for a year",
                    buttonText: "Subscribe for a year",
                    executePayment: () =>
                        controller.sendTypeOfPayment("yearly", context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
