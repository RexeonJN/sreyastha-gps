import 'package:flutter/material.dart';

import 'package:sreyastha_gps/app/core/themes/colors.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    required this.featureTypeToDelete,
    required this.deleteFunction,
    Key? key,
  }) : super(key: key);

  final Function deleteFunction;
  final String featureTypeToDelete;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.3,
      right: 20,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text("Are you sure you want to delete " +
                      featureTypeToDelete +
                      "? "),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "No",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        deleteFunction();
                      },
                      child: Text("Okay"),
                    ),
                  ],
                ),
              );
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
                    Icons.delete,
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
