import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/data/enums/auth_type.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

///if not logged in then it will show either to sign up or login
class AuthenticationButton extends StatelessWidget {
  final BoxConstraints constraints;
  final String displayText;
  final bool signup;
  final bool logout;

  const AuthenticationButton({
    this.signup = false,
    Key? key,
    this.logout = false,
    required this.constraints,
    required this.displayText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (signup) {
          ///to close the navigation drawer
          Navigator.of(context).pop();
          Get.toNamed(Routes.AUTHENTICATION, arguments: AuthMode.Signup);
        } else {
          ///logout when the logout button is pressed
          if (logout) {
            authController.logout();
          }

          ///to close the navigation drawer
          Navigator.of(context).pop();
          Get.toNamed(Routes.AUTHENTICATION, arguments: AuthMode.Login);
        }
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
