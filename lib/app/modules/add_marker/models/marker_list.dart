import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

import 'marker_item.dart';

class MarkerList {
  final Rx<Map<int, MarkerItem?>> _markerList = Rx<Map<int, MarkerItem?>>({});

  ///counter to provide an id for the marker
  int counter = 1;

  ///this attribute can be skipped and is only present as a temporary container
  ///during the addition of the marker.
  MarkerItem? markerItem;

  ///this item holds the id of the currently selected marker which is used to
  ///show the widget containing marker's name, an edit button and a delete button
  final Rx<int?> selectedItem = Rx<int?>(null);

  ///when the widget showing selected marker detail has to removed then
  ///we need to set the id to null as null will never give any marker
  void changeSelectedItem(int? id) {
    selectedItem.value = id;
  }

  ///default look of a marker selected on the map
  Marker _defaultMarker(LatLng markerPoint, int id, Function? onTapped) {
    return Marker(
      height: 25,
      width: 25,
      point: markerPoint,
      builder: (context) => InkWell(
        onTap: () {
          changeSelectedItem(id);

          if (Get.currentRoute == Routes.ADD_MARKER) {
            //this function set the orientation using offset of the detail marker
            onTapped!();
            //print(selectedItem.value);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1,
                  spreadRadius: 1.5,
                  offset: Offset(0, 1)),
            ],
          ),
        ),
      ),
    );
  }

  ///a function to "create" the marker
  void addMarker(LatLng markerPoint, Function? onTapped) {
    markerItem = MarkerItem(
        id: counter,
        name: 'Mark' + (counter).toString(),
        marker: _defaultMarker(markerPoint, counter, onTapped),
        location: markerPoint);
    _markerList.value.putIfAbsent(markerItem!.id, () => markerItem);
    counter++;
  }

  ///"read" the details of the selected marker
  //It is also used as a markerItem to add to the route
  MarkerItem? get selectedItemMarker {
    return selectedItem.value != null && selectedItem.value != 0
        ? _markerList.value[selectedItem.value!]
        : null;
  }

  ///a function to "update" the details of the selected marker
  void updateMarker(String name) {
    _markerList.value[selectedItem.value]!.name = name;
  }

  ///a function to "delete" the marker
  ///Since the id is unique and gets deleted, therefore, the selected value
  ///becomes null
  void deleteMarker() {
    _markerList.value.remove(selectedItem.value);
  }

  ///get a list of all the markers
  Rx<List<Marker>> get markerList {
    Rx<List<Marker>> _listOfMarkers =
        Rx(_markerList.value.values.map((e) => e!.marker).toList());

    return _listOfMarkers;
  }
}
