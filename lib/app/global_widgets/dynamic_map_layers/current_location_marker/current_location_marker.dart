import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocationMarker extends StatelessWidget {
  CurrentLocationMarker(this.ld, {Key? key}) : super(key: key);

  final Position ld;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[300]!.withOpacity(0.7)),
            height: 22,
            width: 22,
          ),
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
            height: 14.0,
            width: 14.0,
          ),
        ],
      ),
    );
  }
}
