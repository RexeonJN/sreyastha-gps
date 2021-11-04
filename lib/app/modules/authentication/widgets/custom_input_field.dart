import 'package:flutter/material.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class CustomTextInputField extends StatefulWidget {
  CustomTextInputField({
    Key? key,
    this.suffixIcon,
    this.controller,
    this.enabled,
    this.hideText,
    required this.labelText,
    required this.hintText,
    this.inputType,
    required this.validator,
    required this.onSaved,
  }) : super(key: key);

  ///This are the only field which will be used to configure a text input field
  final Widget Function(Function onPressed)? suffixIcon;
  final String labelText;
  final String hintText;
  final TextInputType? inputType;
  final String? Function(String? value)? validator;
  final void Function(String? value) onSaved;
  final TextEditingController? controller;
  final bool? enabled;
  final bool? hideText;

  @override
  _CustomTextInputFieldState createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  ///this obscure the text while entering password
  bool _hidePassword = true;

  ///this toggles the password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        enabled: widget.enabled,
        controller: widget.controller,
        obscureText: widget.hideText != null ? _hidePassword : false,
        cursorColor: dark,
        validator: widget.validator,
        keyboardType: widget.inputType,
        onSaved: widget.onSaved,
        decoration: InputDecoration(
          suffix: widget.suffixIcon != null
              ? widget.suffixIcon!.call(() {
                  _togglePasswordVisibility();
                })
              : null,
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
