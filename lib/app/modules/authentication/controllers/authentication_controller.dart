import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/data/enums/auth_type.dart';
import 'package:sreyastha_gps/app/data/exceptions/http_exception.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

class AuthenticationController extends GetxController {
  ///UI will change depending on auth mode
  Rx<AuthMode> authMode = AuthMode.Login.obs;

  void setAuthMode(AuthMode mode) => authMode.value = mode;

  ///Password is stored simply to match wih confirm password field
  final passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  Rx<bool> isLoading = false.obs;

  ///agreement check
  Rx<bool> terms = false.obs;

  ///it holds the data of the authenticated user. Later it will be send for the
  ///verification
  Map<String, dynamic> authData = {
    'name': '',
    'email': '',
    'phonenumber': '',
    'password': '',
    'confirmpassword': ''
  };

  ///
  void _showErrorDialog(String message) {
    Get.dialog(AlertDialog(
      title: Text("An error occured"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("Okay"),
        ),
      ],
    ));
  }

  ///Toggles the authentication mode from signup to login and vice versa
  void switchAuthMode() {
    ///authmode decides which fields to show on the screen
    authMode.value =
        authMode.value == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;

    ///It resets the fields or else when we move from login to sign up
    ///with some values in the fields, those values are also carried to the next
    ///screen
    formKey.currentState!.reset();

    ///similar to set state it updates the UI after the toggle
    update();
  }

  ///After the form is validated, it saves the data in the authData
  Future<void> submit() async {
    ///if validated and terms agreed, then save the form
    if (!formKey.currentState!.validate() ||
        (terms.isFalse && authMode.value == AuthMode.Signup)) {
      return;
    }
    formKey.currentState!.save();

    ///Whenever the loading is true then a circular progress indicator is shown
    ///in place of submit button
    isLoading.value = true;
    update();

    ///either of the signing up or loggin in can fail
    try {
      ///depending on the mode user is logged in or registered
      if (authMode.value == AuthMode.Login) {
        // Log user in
        await authController
            .login(authData["email"], authData["password"])
            .then(
          (value) {
            authController.temporarySubscriptionPassword = authData["password"];

            ///if user is trying to login but hasnt subscribed
            if (value == "Not subscribed") {
              Get.toNamed(Routes.PAYMENT);
              authController.temporarySubscriptionPassword =
                  authData["password"];
            }

            ///if the user has subscribed and is loggin in
            if (value == "Logged in") Get.offAllNamed(Routes.HOME);
          },
        );
      } else {
        ///returns a message that the user has been created and the user id
        await authController
            .signUp(authData["name"], authData["email"], authData["password"],
                authData["phonenumber"], authData["confirmpassword"])
            .then((value) {
          if (value == "User Created") {
            ///assumes that the user will immediately login after signing up
            ///and wont switch email
            Get.dialog(AlertDialog(
              title: Text(
                  "You can now login and subscribe to use premium feature"),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    authMode.value = AuthMode.Login;
                    update();
                  },
                  child: Text("Okay"),
                ),
              ],
            ));
          }
        });
      }
    } on HttpException catch (error) {
      ///this is used when there is a validation error
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    } catch (error) {
      ///this is utilised when the server is not working
      var errorMessage =
          "Could not authenticate you at the moment. Please try again later";
      _showErrorDialog(errorMessage);
    }

    isLoading.value = false;
  }
}
