import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

class PaymentController extends GetxController {
  late Razorpay razorpay;

  ///order id enables us to automatically capture the payments
  ///Otherwise the payments will remain authorised which then needs to capture
  ///in the razorpay dashboard
  String? orderId;

  ///to wait until the payment page opens
  Rx<bool> isLoading = false.obs;

  String? type;

  @override
  void onInit() {
    super.onInit();
    razorpay = new Razorpay();

    ///depending upon the type of payment operation, different kind of
    ///functions are executed
    ///in this events recieve payment and order id which we can use
    ///for future refund or activities
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);

    ///payment failure is not considered as razorpay handles it using
    ///retry payment
  }

  void openCheckout(String type, BuildContext context) {
    ///options contains the settings which  will be shown on clicking the
    ///payment button
    var options = {
      "key": "rzp_test_U5YVfabNOHjkVg",
      "amount": type == "monthly" ? 2000 : 20000,
      "name": "Sample App",
      "order_id": orderId,
      "description": "Payment for some random product",
      "prefill": {
        "contact": authController.phoneNumber,
        "email": authController.email,
      },
      "external": {
        "wallets": ["paytm"]
      }
    };

    ///the web portal of razorpay will be opened in the flutter webview
    ///based on the configuration provided in the settings
    ///if this fails then show a pop up of check your internet connection
    try {
      razorpay.open(options);
    } catch (e) {
      checkInternet(context);
    }
  }

  ///pop up to tell user to check internet
  void checkInternet(BuildContext context) {
    ///an alert box to notify user on internet connection
    AlertDialog(
      content: Text("Kindly check your internet connection."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Okay!"),
        )
      ],
    );
  }

  ///create order id in the server and get it back
  void sendTypeOfPayment(String type, BuildContext context) async {
    isLoading.value = true;

    type = type;

    ///url given to post the type of payment
    final url = Uri.parse('https://orderid-api.herokuapp.com/order_id');

    ///this POST request is sent to my flask server which (if succeeds) then
    ///returns the order id as a response
    try {
      await http
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"amount": type == "monthly" ? 2000 : 20000}),
      )
          .then((response) {
        ///to check whether server is able to fetch order id from razorpay
        if (response.body.isNotEmpty)
          orderId = json.decode(response.body)['id'];
        openCheckout(type, context);
      });
    } catch (e) {
      checkInternet(context);
    }
    isLoading.value = false;
  }

  ///on the success of the payment save subscription is called which
  ///stores the expiry date. If it succeed then send a login and receive a
  ///expiry date of the subscripion.
  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    authController
        .saveSubscription(authController.email!, type == "monthly" ? 30 : 365)
        .then((value) {
      if (value == "subscription saved") {
        Get.dialog(
          AlertDialog(
            title: Text(
              "Your subscription has been added",
            ),
          ),
        );
        Future.delayed(Duration(seconds: 1)).then((value) => Get.back());
        Future.delayed(Duration(seconds: 2)).then((_) async {
          ///whenever this is called, it is called after the login
          ///process so the email and password must have been saved
          await authController
              .login(authController.email!,
                  authController.temporarySubscriptionPassword!)
              .then((value) {
            authController.temporarySubscriptionPassword = null;
            if (value == "Logged in") Get.offAllNamed(Routes.HOME);
          });
        });
      }
    }).onError(
      (error, _) => Get.dialog(
        AlertDialog(
          title: Text(
              "An Internal Error Occured from our side. Kindly call us to update about your subscription. We will respond with a proper email."),
        ),
      ),
    );
  }

  @override
  void onClose() {
    razorpay.clear();
  }
}
