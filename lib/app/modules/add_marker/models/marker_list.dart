import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sreyastha_gps/app/data/enums/marker_input_type.dart';
import 'package:sreyastha_gps/app/data/models/latlng_data.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

import 'marker_item.dart';

class MarkerList {
  final Rx<Map<int, MarkerItem?>> _markerList = Rx<Map<int, MarkerItem?>>({});

  ///counter to provide an id for the marker
  int _counter = 1;

  int get counter => _counter;

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
  Marker _defaultMarker(
      LatLng markerPoint, int id, Function? onTapped, MarkerType markerType) {
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
            color: getColor(markerType),
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
  void addMarker(
      LatLng markerPoint, Function? onTapped, MarkerType markerType) {
    markerItem = MarkerItem(
      id: _counter,
      name: 'Mark' + (_counter).toString(),
      marker: _defaultMarker(markerPoint, _counter, onTapped, markerType),
      location: LatlngData(
        location: markerPoint,
        timestamp: DateTime.now(),
      ),
      markerType: markerType,
    );
    _markerList.value.putIfAbsent(markerItem!.id, () => markerItem);
    _counter++;
  }

  ///"read" the details of the selected marker
  //It is also used as a markerItem to add to the route
  MarkerItem? get selectedItemMarker {
    return selectedItem.value != null && selectedItem.value != 0
        ? _markerList.value[selectedItem.value!]
        : null;
  }

  ///update marker is not required because the marker item passed to the
  ///location marker controller is same as the selected marker item

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

  ///function to get the list of all marker item as a list which can be saved
  ///later in csv
  List<List<dynamic>> get markerListAsList {
    return _markerList.value.values
        .where((element) => element != null)
        .map((e) => e!.listOfAttributes)
        .toList();
  }
}
