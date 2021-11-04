import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class SubscribeButton extends StatelessWidget {
  SubscribeButton({
    required this.buttonText,
    required this.buttonDescriptionText,
    required this.executePayment,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final String buttonDescriptionText;

  final Function executePayment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          buttonDescriptionText,
          softWrap: true,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            executePayment();
          },
          child: Container(
            decoration: BoxDecoration(
              color: active,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              buttonText,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
