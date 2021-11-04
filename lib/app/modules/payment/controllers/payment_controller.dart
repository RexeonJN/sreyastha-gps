import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentController extends GetxController {
  late Razorpay razorpay;

  ///order id enables us to automatically capture the payments
  ///Otherwise the payments will remain authorised which then needs to capture
  ///in the razorpay dashboard
  String? orderId;

  @override
  void onInit() {
    super.onInit();
    razorpay = new Razorpay();

    ///depending upon the type of payment operation, different kind of
    ///functions are executed
    ///in this events recieve payment and order id which we can use
    ///for future refund or activities
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPaymentFailure);
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
        "contact": "10987654321",
        "email": "kundaldeybgp2@gmail.com",
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
  void sendTypeOfPayment(String type, BuildContext context) {
    ///url given to post the type of payment
    final url = Uri.parse('https://orderid-api.herokuapp.com/order_id');

    ///this POST request is sent to my flask server which (if succeeds) then
    ///returns the order id as a response
    try {
      http
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"amount": "5000"}),
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
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print("The RESPONSE is");

    ///On attaining success, register the expiry date of the payment made
  }

  void handlerPaymentFailure(PaymentFailureResponse response) {
    print(response);

    ///On failure, send a pop up that the payment method has failed and in case
    ///we receive the amount we will notify it accordingly
  }

  @override
  void onClose() {
    razorpay.clear();
  }
}
