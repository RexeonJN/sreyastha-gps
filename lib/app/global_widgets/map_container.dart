import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/data/enums/marker_input_type.dart';
import 'package:sreyastha_gps/app/global_widgets/dynamic_map_layers/selected_marker_layer/selected_marker_widget_layer.dart';

import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';
import 'package:sreyastha_gps/app/modules/add_marker/widgets/current_location_marker_button.dart';
import 'package:sreyastha_gps/app/modules/add_marker/widgets/enter_location_button.dart';
import 'package:sreyastha_gps/app/modules/add_marker/widgets/forms/input_location.dart';
import 'package:sreyastha_gps/app/modules/add_track/widgets/tracking_button.dart';

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

  ///screen type this is used in place of get.currentroute
  final String routeType;

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
    double? accuracy,
  })? operateOnMarker;

  ///get selected marker
  ///this also provides a marker item so is not under operate on marker
  final MarkerItem? Function()? getSelectedMarker;

  ///a getter method is used to get the value of the polyline
  final Rx<List<LatLng>> Function()? polylineList;

  ///to get the status of recording of track
  final Rx<bool> Function()? trackRecording;

  final Function(String)? operateOnTrack;

  MapContainer(
    this.obtainedController, {
    required this.routeType,
    this.getSelectedMarker,
    this.operateOnMarker,
    this.markerList,
    this.trackRecording,
    this.polylineList,
    this.operateOnTrack,
    Key? key,
  }) : super(key: key);

  @override
  _MapContainerState createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  ///below are functions related to marker widget
  ///
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
        widget.obtainedController.currentLocation.value != null) {
      setState(() {
        ///updates the markerlist with the current location as marker
        widget.operateOnMarker!("create",
            markerPoint: widget.obtainedController.currentLocation.value!
                .location, onTapped: () {
          ///this function is executed whenever the marker selected
          ///on the map is tapped
          setState(() {});
        },
            markerType: MarkerType.getCurrentLocation,
            altitude: widget.obtainedController.currentLocation.value!.altitude,
            accuracy:
                widget.obtainedController.currentLocation.value!.accuracy);
      });
    }
  }

  void deleteAllMarker() {
    setState(() {
      if (widget.operateOnMarker != null) widget.operateOnMarker!("clearAll");
    });
  }

  ///below are the function related to tracks
  ///
  ///function to start and end tracking of a track item
  void startTracking() {
    if (widget.operateOnTrack != null)
      setState(() {
        widget.operateOnTrack!("startTrack");
      });
  }

  void endTracking() {
    if (widget.operateOnTrack != null)
      setState(() {
        widget.operateOnTrack!("endTrack");
      });
  }

  ///function to delete the track item which is currently shown on the map
  void deleteTrack() {
    setState(() {
      if (widget.operateOnTrack != null) widget.operateOnTrack!("deleteTrack");
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
                onLocationUpdate: () {
                  ///normally location update set state when called in current
                  ///location layer so there is no need to call set state here
                  ///if onlocation update is called in that layer. If it is not
                  ///called then set state can be used
                  ///
                  //adds the new point during tracking
                  if (Get.currentRoute == Routes.ADD_TRACK) {
                    if (widget.trackRecording != null &&
                        widget.trackRecording!().value) {
                      widget.operateOnTrack!("updateTrack");
                    }
                  }
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
                ]),
              ],

              ///plot the current track item in this layer
              if (widget.routeType == "Track")
                PolylineLayerOptions(
                  polylines: [
                    Polyline(
                        points: widget.polylineList!().value,
                        strokeWidth: 4.0,
                        color: Colors.purple)
                  ],
                ),
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

          if (widget.routeType == "Track") ...allTrackWidgets(),
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

  ///contains all the markers which are available in the add marker page
  List<Widget> allTrackWidgets() {
    return [
      ///button to start and end tracking
      ///Unlike the marker save region button is not seperate and is integrated
      ///with the tracking button itself
      ///whenever the user presses end track then file saving is executed
      TrackingButton(
        trackRecording: widget.trackRecording!,
        startTrackFunction: startTracking,
        endTrackFunction: endTracking,
      ),

      ///button to delete the current track
      DeleteButton(
          featureTypeToDelete: "current track", deleteFunction: deleteTrack)
    ];
  }
}
