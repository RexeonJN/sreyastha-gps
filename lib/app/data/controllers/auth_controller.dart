import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreyastha_gps/app/data/exceptions/http_exception.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  Rx<String?> _token = Rx<String?>("");
  Rx<DateTime>? _tokenExpiryDate;

  ///the email,name and the phone number needs to be stored
  /// in the shared preferences so that it
  ///can be shown when the user has logged in
  String? _email;
  String? _name;
  String? _phoneNumber;
  String? _expiryDate;

  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get name => _name;
  String? get expiryDate => _expiryDate;

  ///password of a successful login is saved during subscription
  String? temporarySubscriptionPassword;

  ///this is used to create a timer every time we loggin and ends when the time
  ///of token expiry ends
  Timer? _authTimer;

  ///whenever this is called it checks whether we are logged in or not
  Rx<bool> get isAuth {
    return Rx(token != null);
  }

  ///checks if there is token and the token expiry date has not passed
  ///and finally returns a token
  String? get token {
    if (_tokenExpiryDate != null && _token.value != null) {
      if (_tokenExpiryDate!.value.isAfter(DateTime.now())) return _token.value!;
    }
  }

  ///this is used as common function for login and sign up
  Future<String?> _authenticate(
      String urlSegment, String body, String givenEmail) async {
    _email = givenEmail;
    final url = Uri.parse('https://gpsbackendcode.herokuapp.com/' + urlSegment);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final responseData = json.decode(response.body);

      if (responseData["data"] != null) {
        ///whenever data is present instead of message then stops further
        ///execution and throws error containing the message
        throw HttpException(message: responseData["data"][0]["msg"]);
      }

      ///during login if the email or password is wrong then it will throw
      ///this error
      if (responseData["message"] == "Please check your email or password!") {
        throw HttpException(message: "Please check your email or password!");
      }

      ///is used when the login credentials are correct but the subscription
      ///has not been taken
      if (responseData["response"] == "No subscription") {
        return "Not subscribed";
      }

      ///if the data contains user created during sign up
      ///then return a string which can be used to show pop up that the
      ///user has been created
      if (responseData["message"] == "User Created") {
        return "User Created";
      }

      ///if the data contains token during the login along with subscription
      ///expiry date then check the expiry date
      if (responseData["token"] != null) {
        _token.value = responseData["token"];
        _tokenExpiryDate = Rx(DateTime.now().add(Duration(days: 1)));

        var tempTime = DateTime.parse(responseData["subscriptionDuration"]);
        _expiryDate = "${tempTime.day}-${tempTime.month}-${tempTime.year}";

        _name = responseData["name"];
        _phoneNumber = responseData["phonenumber"].toString();

        ///whenever i log in i update tokenexpirydate, then i start a timer
        ///which continues for a day then it calls a logout function
        ///when we restart the app we use token
        ///from stored shared preference and try login
        autoLogout();

        final prefs = await SharedPreferences.getInstance();

        ///storing the data in the shared preferences
        ///only token and expiry date are to updated during autologging
        final userData = json.encode({
          "token": _token.value,
          "expiryDate": _tokenExpiryDate!.value.toIso8601String(),
          "phonenumber": phoneNumber,
          "email": email,
          "name": name,
          "susbcriptionExpiryDate": expiryDate,
        });

        ///write the data
        prefs.setString('userData', userData);
        return "Logged in";
      }
    } catch (error) {
      ///throws the error message sent by server
      throw error;
    }
  }

  ///this is used to sign up
  Future<String?> signUp(String name, String email, String password,
      String phoneNumber, String confirmPassword) async {
    final data = {
      "name": name,
      "email": email,
      "phonenumber": phoneNumber,
      "password": password,
      "confirmpassword": confirmPassword
    };

    ///waits for authenticate to complete
    return _authenticate("signup", jsonEncode(data), email);
  }

  //this is used to login
  Future<String?> login(String email, String password) async {
    final data = {"email": email, "password": password};

    return _authenticate("login", jsonEncode(data), email);
  }

  ////this is called whenever the subscription has been taken
  ///it updates the expiry date of the subscription for that user which is
  ///returned after every login
  Future<String?> saveSubscription(String email, int durationIndays) async {
    final data = {"email": email, "subscriptionDuration": durationIndays};
    final url =
        Uri.parse('https://gpsbackendcode.herokuapp.com/saveSubscription');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      final responseData = json.decode(response.body);

      ///only when the subscription is saved only then the automamtic login
      ///is called
      if (responseData["message"] == "Subscription saved") {
        //_expiryDate = DateTime.parse(responseData["date"]);
        return "subscription saved";
      }
    } catch (error) {
      ///throws the error message sent by server
      throw error;
    }
  }

  ///this  resets every variable so that the isAuth returns false which can
  ///be used to check whether logged in or not
  Future<void> logout() async {
    _token.value = null;
    _tokenExpiryDate = null;

    ///no need to nullify all other variables as they will not be seen or used if
    ///isAuth returns false  because of this two variables
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }

  ///whenever we move out of the app we logout automatically
  ///this only run if the user contnuosly use the app for more than a day
  ///without closing the app
  void autoLogout() {
    ///with every new login it will first remove the old timer
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    ///this provides a fixed time until which the timer runs if the
    ///app is not shut down
    //final timeToExpiry =_tokenExpiryDate!.value.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(minutes: 10), () {
      logout();
    });
  }

  ///check whether is data is stored in shared reference or not
  ///this is used to automatically log using the token saved in the
  ///shared preferences
  Future<bool> tryAutoLogging() async {
    final prefs = await SharedPreferences.getInstance();

    ///contains the userData having token
    if (!prefs.containsKey("userData")) {
      return false;
    }

    ///getting userData stored in the shared preferences
    final extractedUserData = json.decode(prefs.getString("userData")!);
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]!);

    ///token has expired ie. is it after a day

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    ///as the data stored is valid and can be used to login again
    _token.value = extractedUserData["token"];
    _tokenExpiryDate = Rx(expiryDate);
    _name = extractedUserData["name"];
    _phoneNumber = extractedUserData["phonenumber"];
    _email = extractedUserData["email"];
    _expiryDate = extractedUserData["susbcriptionExpiryDate"];

    autoLogout();
    update();
    print(_expiryDate);
    return true;
  }
}
