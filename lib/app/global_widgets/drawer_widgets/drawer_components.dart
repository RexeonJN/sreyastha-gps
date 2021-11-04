import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/data/enums/auth_type.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

class AuthenticationButton extends StatelessWidget {
  final BoxConstraints constraints;
  final String displayText;
  final bool signup;

  const AuthenticationButton({
    this.signup = false,
    Key? key,
    required this.constraints,
    required this.displayText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (signup)
          Get.toNamed(Routes.AUTHENTICATION, arguments: AuthMode.Signup);
        Get.toNamed(Routes.AUTHENTICATION, arguments: AuthMode.Login);
      },
      child: Container(
        height: constraints.maxHeight * 0.04,
        width: constraints.maxWidth * 0.35,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            displayText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
