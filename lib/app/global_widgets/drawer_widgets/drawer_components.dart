import 'package:flutter/material.dart';

class AuthenticationButton extends StatelessWidget {
  final BoxConstraints constraints;
  final String displayText;

  const AuthenticationButton(
      {Key? key, required this.constraints, required this.displayText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
