import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class RoutingButton extends StatelessWidget {
  RoutingButton(
      {required this.startCreating,
      required this.endCreating,
      required this.creationStatus,
      Key? key})
      : super(key: key);

  final Rx<bool> Function() creationStatus;
  final Function startCreating;
  final Function endCreating;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      top: MediaQuery.of(context).size.height / 2.2,
      child: InkWell(
        onTap: () {
          !creationStatus().value ? startCreating() : endCreating();
        },
        //button looks similar to a floating action button
        child: Container(
          height: 50,
          width: 50,
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
          child:

              ///depending upon whether the track is recording the
              /// icon switches
              ///to track it obx is needed
              !creationStatus().value
                  ? Icon(
                      Icons.play_arrow,
                      color: light,
                    )
                  : Icon(
                      Icons.stop,
                      color: light,
                    ),
        ),
      ),
    );
  }
}
