import 'package:flutter/material.dart';

enum MarkerType {
  getCurrentLocation,
  enterLocation,
  markOnMap,
}

String asStrings(MarkerType markerType) {
  switch (markerType) {
    case MarkerType.markOnMap:
      return "Marked on Map";
    case MarkerType.getCurrentLocation:
      return "current location was marked";
    case MarkerType.enterLocation:
      return "Manually given Location";
    default:
      return "Marked on Map";
  }
}

Color getColor(MarkerType markerType) {
  switch (markerType) {
    case MarkerType.markOnMap:
      return Colors.indigo;
    case MarkerType.enterLocation:
      return Colors.amber;
    case MarkerType.getCurrentLocation:
      return Colors.white;
    default:
      return Colors.white;
  }
}
