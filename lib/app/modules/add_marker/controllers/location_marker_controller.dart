import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';

////this controller is used while taking input in the location input. location
///input widget is used to create or update marker
class LocationMarkerController extends GetxController {
  final latitudeFocusNode = FocusNode();
  final longitudeFocusNode = FocusNode();
  final altitudeFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rx<MarkerItem> editedMarkerItem;

  LocationMarkerController({
    required this.editedMarkerItem,
  });

  void saveForm(BuildContext context) {
    if (formKey.currentState == null || !formKey.currentState!.validate())
      return;

    formKey.currentState!.save();

    Navigator.of(context).pop();
  }

  @override
  void onClose() {
    latitudeFocusNode.dispose();
    descriptionFocusNode.dispose();
  }
}
