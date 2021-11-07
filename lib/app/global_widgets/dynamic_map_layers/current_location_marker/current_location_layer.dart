import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '/app/core/constants/controllers.dart' show locationController;
import '/app/data/controllers/gps_location_controller.dart'
    show LocationServiceStatus;
import '/app/global_widgets/dynamic_map_layers/current_location_marker/current_location_marker.dart'
    show CurrentLocationMarker;
import '/app/global_widgets/dynamic_map_layers/current_location_marker/current_location_options.dart';

CurrentLocationMarkerBuilder _defaultMarkerBuilder =
    (BuildContext context, Position ld) {
  return Marker(
      point: LatLng(ld.latitude, ld.longitude),
      builder: (_) => CurrentLocationMarker(ld),
      height: 60,
      width: 60,
      rotate: false);
};

class CurrentLocationLayer extends StatefulWidget {
  const CurrentLocationLayer(this.options, this.map, this.stream, {Key? key})
      : super(key: key);

  ///this three parameters are required by LayerOptions to extend its function
  final CurrentLocationOptions options;
  final MapState map;
  final Stream<Null> stream;

  @override
  _CurrentLocationLayerState createState() => _CurrentLocationLayerState();
}

class _CurrentLocationLayerState extends State<CurrentLocationLayer>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    _initOnLocationUpdateSubscription();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  void _initOnLocationUpdateSubscription() async {
    if (!await locationController.requestPermissions()) {
      locationController.currentServiceStatus.value =
          LocationServiceStatus.permissionDenied;
      return;
    }

    await locationController.unsubscribePosition();
    locationController.subscribePosition(LocationAccuracy.best);

    locationController.currentServiceStatus.value =
        LocationServiceStatus.subscribed;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        locationController.unsubscribePosition();
        if (locationController.currentServiceStatus.value ==
            LocationServiceStatus.subscribed) {
          locationController.currentServiceStatus.value =
              LocationServiceStatus.paused;
        } else {
          locationController.currentServiceStatus.value =
              LocationServiceStatus.unknown;
        }
        break;
      case AppLifecycleState.resumed:
        if (locationController.currentServiceStatus.value ==
            LocationServiceStatus.paused) {
          locationController.currentServiceStatus.value =
              LocationServiceStatus.unknown;
          _initOnLocationUpdateSubscription();
        }
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        Obx(() {
          ///whenever a new value of current location then onLocationUpdate
          ///is called which calls setState
          widget.options.onLocationUpdate!.call();
          if (locationController.currentLocation.value == null)
            return Container();
          final Marker? marker = locationController.currentPosition != null
              ? _defaultMarkerBuilder(
                  context, locationController.currentPosition!)
              : null;
          return marker != null
              ? MarkerLayerWidget(
                  options: MarkerLayerOptions(
                    markers: <Marker>[
                      marker,
                    ],
                  ),
                )
              : Container();
        }),
      ],
    ));
  }
}
