import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class TotalDistance extends StatelessWidget {
  const TotalDistance({required this.totalDistance, Key? key})
      : super(key: key);

  final Rx<double> Function() totalDistance;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.8,
      left: 10,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: light,
        ),
        child: Text('${totalDistance().value}'),
      ),
    );
  }
}
