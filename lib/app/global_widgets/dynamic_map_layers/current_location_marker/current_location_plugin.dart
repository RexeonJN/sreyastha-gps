import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';

import 'current_location_layer.dart';
import 'current_location_options.dart';

class CurrentLocationPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is CurrentLocationOptions) {
      return CurrentLocationLayer(options, mapState, stream);
    }
    throw ArgumentError('options is not of type LocationOptions');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is CurrentLocationOptions;
  }
}
