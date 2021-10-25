import 'package:flutter/material.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';

class SelectedMarkerWidget extends StatelessWidget {
  SelectedMarkerWidget(
      {required this.deleteFunction,
      required this.updateFunction,
      required this.markerItem,
      Key? key})
      : super(key: key);

  final MarkerItem markerItem;
  final Function deleteFunction;
  final Function updateFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: light,
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(1, 1),
                color: Colors.grey)
          ]),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(markerItem.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: active,
                  ),
                  onPressed: () async {
                    await updateFunction();
                  },
                ),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => deleteFunction()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
