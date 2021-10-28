import 'package:flutter/material.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class EnterLocationButton extends StatelessWidget {
  EnterLocationButton({required this.locationFunction, Key? key})
      : super(key: key);

  final Function locationFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top +
                MediaQuery.of(context).size.height * 0.07,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: active,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: Offset(1, 1),
                          color: Colors.grey)
                    ]),
                child: InkWell(
                  onTap: () {
                    locationFunction();
                  },
                  child: Row(
                    children: [
                      Text(
                        "Enter location to create marker",
                        textScaleFactor: 1.1,
                        style: TextStyle(
                          color: light,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
