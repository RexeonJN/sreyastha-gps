import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';

class LocationMarkerController extends GetxController {
  final latitudeFocusNode = FocusNode();
  final longitudeFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rx<MarkerItem> editedMarkerItem;
  Function(MarkerItem) updateMarker;

  LocationMarkerController(
      {required this.editedMarkerItem, required this.updateMarker});

  void saveForm(BuildContext context) {
    if (formKey.currentState == null || !formKey.currentState!.validate())
      return;

    formKey.currentState!.save();
    updateMarker(editedMarkerItem.value);

    Navigator.of(context).pop();
  }

  @override
  void onClose() {
    latitudeFocusNode.dispose();
    descriptionFocusNode.dispose();
  }
}
