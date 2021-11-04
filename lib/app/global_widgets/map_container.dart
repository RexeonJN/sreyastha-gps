import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/data/enums/marker_input_type.dart';
import 'package:sreyastha_gps/app/global_widgets/dynamic_map_layers/selected_marker_layer/selected_marker_widget_layer.dart';

import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';
import 'package:sreyastha_gps/app/modules/add_marker/widgets/current_location_marker_button.dart';
import 'package:sreyastha_gps/app/modules/add_marker/widgets/enter_location_button.dart';
import 'package:sreyastha_gps/app/modules/add_marker/widgets/forms/input_location.dart';

import 'package:sreyastha_gps/app/routes/app_pages.dart';

import 'delete_button.dart';
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
  final dynamic obtainedController;

  ///a getter method is used to get the value of the markerList
  ///if it were a List of markers then it wont update whenever a new marker was
  ///added by controller
  ///? is used to make it optional for other controllers
  ///it is not put inside the operate on marker becasue switch case is
  /// not returning anything
  final Rx<List<Marker>> Function()? markerList;

  ///a function to perform CRUD operation with selected marker
  final Function(
    String, {
    LatLng? markerPoint,
    Function? onTapped,
    MarkerType? markerType,
    double? altitude,
  })? operateOnMarker;

  ///get selected marker
  ///this also provides a marker item so is not under operate on marker
  final MarkerItem? Function()? getSelectedMarker;

  ///screen type this is used in place of get.currentroute
  final String routeType;

  MapContainer(
    this.obtainedController, {
    this.markerList,
    this.operateOnMarker,
    this.getSelectedMarker,
    required this.routeType,
    Key? key,
  }) : super(key: key);

  @override
  _MapContainerState createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  ///this function is passed as an update function to the input location form
  ///depending upon the type some of the features will be shown or hidden
  void updateFunction(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return LocationMarkerInput(
            markerItem: widget.getSelectedMarker!()!,
          );
        }).then((value) {
      if (widget.getSelectedMarker != null &&
          widget.getSelectedMarker!() != null)
        setState(() {
          /// this deletes the marker if the alert dialog was popped up
          /// without entering any value

          if (widget.getSelectedMarker != null &&
              widget.getSelectedMarker!() != null &&
              widget.getSelectedMarker!()!.location.location.latitude == -90.0)
            widget.operateOnMarker!("delete");

          ///this resets to null the selected marker widget shown after the pop
          ///is removed
          widget.operateOnMarker!("resetItem");
        });
    });
  }

  ///function to manually mark location ont he map
  void manuallyEnterLocation() {
    if (widget.operateOnMarker != null)
      widget.operateOnMarker!("create", markerPoint: LatLng(-90, 0),
          onTapped: () {
        ///there is no need to update the markerlist on the map because after
        ///its creation a pop up has to open
        setState(() {});
      }, markerType: MarkerType.enterLocation);

    ///id of the last marker will be counter -1 as the counter increases
    ///after the creation of marker
    if (widget.operateOnMarker != null)
      widget.operateOnMarker!("changeSelectedItem");

    if (widget.getSelectedMarker != null && widget.getSelectedMarker!() != null)
      updateFunction(context);
  }

  ///to mark current location as the marker
  void currentLocationAsMarker() {
    if (widget.operateOnMarker != null &&
        locationController.currentLocation.value != null) {
      setState(() {
        ///updates the markerlist with the current location as marker
        widget.operateOnMarker!("create",
            markerPoint: locationController.currentLocation.value!.location,
            onTapped: () {
          ///this function is executed whenever the marker selected
          ///on the map is tapped
          setState(() {});
        },
            markerType: MarkerType.getCurrentLocation,
            altitude: locationController.currentLocation.value!.altitude);
      });
    }
  }

  void deleteAllMarker() {
    setState(() {
      storageController.clearAllMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => Stack(
        children: [
          FlutterMap(
            mapController:
                widget.obtainedController.customMapController().mapController,
            options: MapOptions(
              onPositionChanged: (mapPosition, positionChanged) {
                ///if the map is loading for the first time then it wont update
                ///the UI. However, if the map has been loaded then it will
                ///update the horizontal distance bar
                widget.obtainedController
                    .customMapController()
                    .changeDistance();

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
                    widget.operateOnMarker!("resetItem");
                  });
              },
              onLongPress: (position, markerPoint) {
                if (widget.operateOnMarker != null) {
                  setState(() {
                    ///updates the markerlist which is stored in addmarker
                    ///controller
                    widget.operateOnMarker!("create", markerPoint: markerPoint,
                        onTapped: () {
                      ///this function is executed whenever the marker selected
                      ///on the map is tapped
                      setState(() {});
                    }, markerType: MarkerType.markOnMap);
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
                ///currently the cycle of reseting the widget is set on
                ///the new current location which is obtained
                ///However, any logic can used such as a real timer set to
                ///certain duration can also be used
                onLocationUpdate: () {},
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
                      point: widget.getSelectedMarker!()!.location.location,
                      builder: (ctx) => SelectedMarkerWidget(
                        markerItem: widget.getSelectedMarker!()!,
                        deleteFunction: () {
                          setState(() {
                            if (widget.getSelectedMarker != null &&
                                widget.getSelectedMarker!() != null)
                              widget.operateOnMarker!("delete");
                          });
                        },
                        updateFunction: () {
                          ///this will update both marker details and UI

                          if (widget.getSelectedMarker != null &&
                              widget.getSelectedMarker!() != null)
                            updateFunction(context);
                        },
                      ),
                    ),
                ])
              ],
            ],
          ),

          ///new instance of the controller can be passed as they aren't
          ///associated with any data
          MapZoomButton(widget.obtainedController.customMapController),
          HorizontalDistanceBar(
            widget.obtainedController.customMapController,
            constraints: constraints,
          ),

          ///route Type is used in place of getroute because get route takes
          ///time to finish and the widgets remain even after the page has
          ///disappeared so string conditions are used which would not wait
          ///for page to disappear
          if (widget.routeType == "Markers") ...allMarkerWidgets(),
        ],
      ),
    );
  }

  ///contains all the markers which are available in the add marker page
  List<Widget> allMarkerWidgets() {
    return [
      ///this is a button to enter the location manually which will
      /// eventually be marked on the map
      ///button to enter the latitude and longitude of a location
      EnterLocationButton(
        locationFunction: manuallyEnterLocation,
      ),

      ///button to convert the current location into a marker
      CurrentLocationMarkerButton(
        locationFunction: currentLocationAsMarker,
      ),

      ///button to delete the markers
      DeleteButton(
          featureTypeToDelete: "all markers", deleteFunction: deleteAllMarker)
    ];
  }
}
