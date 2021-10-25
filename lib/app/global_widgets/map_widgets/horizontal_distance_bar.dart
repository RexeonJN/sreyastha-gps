import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sreyastha_gps/app/core/themes/colors.dart';

class HorizontalDistanceBar extends StatelessWidget {
  final Function getController;
  HorizontalDistanceBar(
    this.getController, {
    required BoxConstraints constraints,
    Key? key,
  })  : _constraints = constraints,
        super(key: key);

  final BoxConstraints _constraints;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      width: _constraints.maxWidth,
      height: 40,
      child: Container(
        color: Colors.white.withOpacity(0.5),
        child: Column(
          children: [
            //to show the distance in km and m
            Expanded(
              child: Center(
                child: Obx(
                  () => Text(
                    getController().longitudinalDistanceShown.value > 1000
                        ? '${(getController().longitudinalDistanceShown.value / 1000).toStringAsFixed(2)}  km'
                        : '${getController().longitudinalDistanceShown.value.toStringAsFixed(2)} m',
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: dark,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            // to draw the zebra pattern below the distance
            Row(
              children: [1, 2, 3, 4, 5, 6, 7]
                  .map(
                    (index) => Container(
                      height: 10,
                      width: _constraints.maxWidth / 7,
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? dark : light,
                        border: Border.all(color: dark, width: 1),
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
