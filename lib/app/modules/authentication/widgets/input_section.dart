import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/data/enums/auth_type.dart';
import 'package:sreyastha_gps/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:sreyastha_gps/app/modules/authentication/widgets/custom_input_field.dart';

///Section where users input details during registering or logging in
class InputSection extends StatelessWidget {
  const InputSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AuthenticationController>(
      builder: (controller) => Column(
        children: [
          ///first name of user can be entered during their registration
          if (controller.authMode == AuthMode.Signup) ...[
            CustomTextInputField(
              enabled: controller.authMode == AuthMode.Signup,
              labelText: "Name",
              hintText: "John Doe",
              inputType: TextInputType.name,
              validator: (value) {
                ///It simply checks whether the name of the user is entered
                if (value!.isEmpty) {
                  return 'Enter your first name';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) controller.authData['name'] = value;
              },
            ),
            _verticalGap(),
          ],

          ///User can enter an email
          CustomTextInputField(
            labelText: "Email",
            hintText: "JohnDoe@domain.com",
            inputType: TextInputType.emailAddress,
            validator: (value) {
              ///to check whether the email is valid or not
              if (value!.isEmpty || !value.isEmail) {
                return 'Invalid email!';
              }
              return null;
            },
            onSaved: (value) {
              if (value != null) controller.authData['email'] = value;
            },
          ),
          _verticalGap(),

          ///User can enter a phone number
          if (controller.authMode == AuthMode.Signup)
            CustomTextInputField(
              labelText: "phone number",
              hintText: "9876543210",
              inputType: TextInputType.number,
              validator: (value) {
                ///to check whether the phone number is valid or not
                if (value != null) {
                  int? _checkValue = int.tryParse(value);
                  if (_checkValue == null ||
                      _checkValue.isLowerThan(1000000000)) {
                    return 'Invalid phone number';
                  }
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) controller.authData['phonenumber'] = value;
              },
            ),
          _verticalGap(),

          ///User can enter the password which needs to be checked with confirm
          ///password during the registration process

          CustomTextInputField(
            labelText: "Password",
            hintText: "12345",
            hideText: true,
            inputType: TextInputType.visiblePassword,
            controller: controller.passwordController,
            suffixIcon: (onPressed) {
              return InkWell(
                onTap: () => onPressed(),
                child: Icon(
                  Icons.remove_red_eye,
                  color: dark,
                ),
              );
            },
            validator: (value) {
              ///Password must not be less than 8 digit
              if (value!.isEmpty || value.length < 9) {
                return 'Password is too short!';
              }

              ///Password should contain atleast a capital letter, number and a
              ///special symbol
              return null;
            },
            onSaved: (value) {
              if (value != null) controller.authData['password'] = value;
            },
          ),
          _verticalGap(),
          if (controller.authMode == AuthMode.Signup)
            CustomTextInputField(
              enabled: controller.authMode == AuthMode.Signup,
              labelText: "Confirm Password",
              hintText: "12345",
              hideText: true,
              suffixIcon: (onPressed) {
                return InkWell(
                  onTap: () => onPressed(),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: dark,
                  ),
                );
              },
              validator: controller.authMode == AuthMode.Signup
                  ? (value) {
                      if (value != controller.passwordController.text) {
                        return 'Passwords do not match!';
                      }
                    }
                  : null,
              onSaved: (value) {
                if (value != null)
                  controller.authData['confirmpassword'] = value;
              },
            ),
        ],
      ),
    );
  }

  ///it creates a consistent gapping in between two widgets
  Widget _verticalGap() {
    return SizedBox(
      height: 15,
    );
  }
}
