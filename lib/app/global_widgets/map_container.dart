import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '/app/core/constants/controllers.dart';
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
                customMapController.changeDistance();
                customMapController.moveToCurrentLocation();
              },

              crs: const Epsg3857(),
              zoom: 16,
              maxZoom: 18.499,
              minZoom: 3,
              //dont do LatLng(0,0) which will show null island
              center: LatLng(25, 86),
              //rotation rotates other widgets in the layer
              //name on the map doesnt rotate
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
            layers: <LayerOptions>[
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: <String>['a', 'b', 'c'],
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
