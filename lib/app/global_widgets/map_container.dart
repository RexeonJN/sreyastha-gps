import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/global_widgets/dynamic_map_layers/selected_marker_layer/selected_marker_widget_layer.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';

import 'package:sreyastha_gps/app/routes/app_pages.dart';

import 'dynamic_map_layers/current_location_marker/current_location_options.dart';
import 'dynamic_map_layers/current_location_marker/current_location_plugin.dart';
import 'map_widgets/horizontal_distance_bar.dart';
import 'map_widgets/map_zoom_button.dart';

///Making it a stateful widget is necessary because it is not connected with the
///controller and therefore cant be updated whenever the controller needs to
///update the data
///connecting the data is not obvious as various views with their own controllers
///are accessing the map container
class MapContainer extends StatefulWidget {
  ///Making it dynamic allows me to take either HomeController, AddMarkerController
  ///or any other controller which is to be accessed in map container
  ///However, it will only have methods which dont have any data associated with it
  final dynamic controller;

  ///a getter method is used to get the value of the markerList
  ///if it were a List of markers then it wont update whenever a new marker was
  ///added by controller
  ///? is used to make it optional for other controllers
  final Rx<List<Marker>> Function()? markerList;

  ///a function to perform CRUD operation with selected marker
  final Function(String, LatLng?, Function?)? operateOnMarker;

  ///get selected marker
  final MarkerItem? Function()? getSelectedMarker;

  MapContainer(
    this.controller, {
    this.markerList,
    this.operateOnMarker,
    this.getSelectedMarker,
    Key? key,
  }) : super(key: key);

  @override
  _MapContainerState createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => Stack(
        children: [
          FlutterMap(
            mapController:
                widget.controller.customMapController().mapController,
            options: MapOptions(
              onPositionChanged: (mapPosition, positionChanged) {
                ///if the map is loading for the first time then it wont update
                ///the UI. However, if the map has been loaded then it will
                ///update the horizontal distance bar
                widget.controller.customMapController().changeDistance();

                ///whenever the position of the map is change the selectedItem
                ///Widget vanishes because selected item is set to 0 and
                ///orientation of LatLng is set to null
                if (widget.operateOnMarker != null) {
                  ///this delays the operation of the executing the function
                  ///therby preventing any error during the build state
                  Future.delayed(Duration(milliseconds: 10))
                      .then((value) => setState(() {}));
                }
              },
              onTap: (tapPosition, point) {
                ///whenever the map is tapped, then the markerLocation
                ///is set to null
                if (widget.getSelectedMarker != null &&
                    widget.getSelectedMarker!() != null)
                  setState(() {
                    ///operate on marker and the getselected marker are passed
                    ///by the same add marker page
                    widget.operateOnMarker!("resetItem", null, null);
                  });
                ;
              },
              onLongPress: (position, markerPoint) {
                if (widget.operateOnMarker != null) {
                  setState(() {
                    ///updates the markerlist which is stored in addmarker
                    ///controller
                    widget.operateOnMarker!("create", markerPoint, () {
                      ///this function is executed whenever the marker selected
                      ///on the map is tapped
                      setState(() {});
                    });
                  });
                }
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
              //display all the marker chosen in the marker list
              if (Get.currentRoute == Routes.ADD_MARKER &&
                  widget.markerList != null) ...[
                ///this provides a layer of all the marker on the map
                MarkerLayerOptions(markers: widget.markerList!().value),

                ///the selected marker can be tapped to open selected marker
                ///widget. the widget is considered to be a marker so as to
                ///ease the implementation
                MarkerLayerOptions(markers: [
                  ///if selected marker is not null then show detail widget as
                  ///a marker otherwise, dont show any marker
                  if (widget.getSelectedMarker != null &&
                      widget.getSelectedMarker!() != null)
                    Marker(
                      width: 200,
                      height: 40,
                      point: widget.getSelectedMarker!()!.location,
                      builder: (ctx) => SelectedMarkerWidget(
                        markerItem: widget.getSelectedMarker!()!,
                        deleteFunction: () {
                          setState(() {
                            if (widget.getSelectedMarker != null &&
                                widget.getSelectedMarker!() != null)
                              widget.operateOnMarker!("delete", null, null);
                          });
                        },
                        updateFunction: () {},
                      ),
                    ),
                ])
              ],
            ],
          ),

          ///new instance of the controller can be passed as they aren't
          ///associated with any data
          MapZoomButton(widget.controller.customMapController),
          HorizontalDistanceBar(
            widget.controller.customMapController,
            constraints: constraints,
          ),
        ],
      ),
    );
  }
}
