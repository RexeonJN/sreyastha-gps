import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

typedef CurrentLocationMarkerBuilder = Marker Function(
    BuildContext context, Position ld);

class CurrentLocationOptions extends LayerOptions {
  final void Function()? onLocationUpdate;

  final Duration updateInterval;
  final CurrentLocationMarkerBuilder? markerBuilder;
  final LocationAccuracy locationAccuracy;
  final bool initiallyRequest;

  CurrentLocationOptions({
    this.markerBuilder,
    this.onLocationUpdate,
    this.updateInterval = const Duration(seconds: 1),
    this.locationAccuracy = LocationAccuracy.best,
    this.initiallyRequest = true,
  });
}
