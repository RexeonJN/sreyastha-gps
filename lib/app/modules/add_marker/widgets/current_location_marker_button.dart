import 'package:flutter/material.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class CurrentLocationMarkerButton extends StatelessWidget {
  const CurrentLocationMarkerButton({
    Key? key,
    required this.locationFunction,
  }) : super(key: key);

  final Function locationFunction;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      bottom: MediaQuery.of(context).size.height * 0.5,
      child: InkWell(
        onTap: () {
          locationFunction();
        },
        child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: active,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset(1, 1),
                      color: Colors.grey)
                ]),
            child: Icon(Icons.location_on, color: light)),
      ),
    );
  }
}
