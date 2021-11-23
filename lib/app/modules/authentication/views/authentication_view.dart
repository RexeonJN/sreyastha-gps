import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/data/enums/auth_type.dart';
import 'package:sreyastha_gps/app/modules/authentication/widgets/input_section.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

import '../controllers/authentication_controller.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  @override
  Widget build(BuildContext context) {
    //Depending on what waas selected on the drawer, it either opens login
    //or sign up page
    controller.setAuthMode(Get.arguments);
    List<List<Widget>> _middleSectionWidgets = <List<Widget>>[
      [companyBrandHeading()],
      [
        inputSection(),
        Obx(() => controller.authMode.value == AuthMode.Login
            ? rememberOrForgetPassword()
            : customerAgreement())
      ],
      [
        Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: active,
                  ),
                )
              : loginOrSignupButton(),
        ),
      ],
      [toggleSignUpOrLogin()]
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(25),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._middleSectionWidgets
                      .expand(
                          (element) => element.followedBy([_horizontalGap()]))
                      .toList()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget companyBrandHeading() {
    return Column(children: [
      Container(
        child: Text(
          "Sreyastha GPS",
          textScaleFactor: 1.4,
          style: TextStyle(
            color: active,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      _horizontalGap(),
    ]);
  }

  Widget inputSection() {
    return InputSection();
  }

  ///TODO:to add forgot password
  ///TODO:to add reset password
  Widget rememberOrForgetPassword() {
    return Column(
      children: [
        _horizontalGap(),
        _horizontalGap(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Forgot password?",
              style: TextStyle(color: active),
            ),
          ],
        ),
      ],
    );
  }

  Row customerAgreement() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => Checkbox(
              value: controller.terms.value,
              onChanged: (_) {
                controller.terms.value = !controller.terms.value;
              },
            ),
          ),
        ),

        /// move to terms and conditions page
        TextButton(
          onPressed: () {
            Get.toNamed(Routes.TERMS_AND_CONDITIONS);
          },
          child: Text(
            "I agree with all the terms and conditions",
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  InkWell loginOrSignupButton() {
    return InkWell(
      onTap: () => controller.submit(),
      child: Container(
        decoration: BoxDecoration(
          color: active,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Obx(
          () => Text(
            controller.authMode == AuthMode.Login ? "Login" : "SignUp",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget toggleSignUpOrLogin() {
    return Obx(
      () => Row(
        children: [
          Text(
            controller.authMode.value == AuthMode.Login
                ? "Do not have an account yet?"
                : "Already have an account?",
            style: TextStyle(color: dark),
          ),
          Expanded(child: Container()),
          TextButton(
            child: Text(
              controller.authMode.value == AuthMode.Login ? "Sign Up" : "Login",
              textScaleFactor: 1.2,
              style: TextStyle(
                color: active,
              ),
            ),
            onPressed: () {
              controller.switchAuthMode();
            },
          ),
        ],
      ),
    );
  }

  Widget _horizontalGap() {
    return SizedBox(
      height: 15,
    );
  }
}
