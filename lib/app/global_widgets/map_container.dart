import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '/app/core/constants/controllers.dart';
import 'dynamic_map_layers/current_location_marker/current_location_options.dart';
import 'dynamic_map_layers/current_location_marker/current_location_plugin.dart';
import 'map_widgets/horizontal_distance_bar.dart';
import 'map_widgets/map_zoom_button.dart';

class MapContainer extends StatelessWidget {
  MapContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => Stack(
        children: [
          FlutterMap(
            mapController: customMapController.mapController,
            options: MapOptions(
              onPositionChanged: (mapPosition, positionChanged) {
                ///if the map is loading for the first time then it wont update
                ///the UI. However, if the map has been loaded then it will
                ///update the horizontal distance bar
                customMapController.changeDistance();
              },

              crs: const Epsg3857(),
              zoom: 16,
              maxZoom: 18.499,

              ///maximum zoom possible
              minZoom: 3,
              //dont do LatLng(0,0) which will show null island
              center: LatLng(25, 86),
              //rotation rotates other widgets in the layer
              //However, the name on the map doesnt rotate
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              plugins: <MapPlugin>[
                CurrentLocationPlugin(),
              ],
            ),
            layers: <LayerOptions>[
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: <String>['a', 'b', 'c'],
              ),
              CurrentLocationOptions(
                onLocationUpdate: (Position? ld) {
                  print(
                      'Location updated:${ld.toString()} (accuracy: ${ld?.accuracy}');
                },
              ),
            ],
          ),
          MapZoomButton(),
          HorizontalDistanceBar(
            constraints: constraints,
          ),
        ],
      ),
    );
  }
}
