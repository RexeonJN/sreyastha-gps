import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/data/enums/auth_type.dart';
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
  Map<String, String> authData = {
    'first name': '',
    'last name': '',
    'email': '',
    'password': '',
  };

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
  void submit() {
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

    ///depending on the mode user is logged in or registered
    if (authMode.value == AuthMode.Login) {
      // Log user in
      print(authData);
      if (authData['email'] == 'kunaldeybgp2@gmail.com' &&
          authData['password'] == '123456789') {
        Get.toNamed(Routes.PAYMENT);
      }
    } else {
      // Sign user up
      print("registered");
    }

    ///TODO:Timer is there only to show the delay in the authentication from the
    ///server. Once it is connected with the server then the timer needs
    /// to be removed
    Timer(Duration(seconds: 5), () {
      isLoading.value = false;
    });
  }
}
