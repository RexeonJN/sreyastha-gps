import 'package:flutter/material.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class UndoLastButton extends StatelessWidget {
  UndoLastButton({
    required this.deleteFunction,
    Key? key,
  }) : super(key: key);

  final Function deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.7,
      right: 20,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              deleteFunction();
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: light,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(1, 1),
                        color: Colors.grey)
                  ]),
              child: Row(
                children: [
                  Icon(
                    Icons.undo,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
