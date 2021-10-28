import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/data/enums/marker_input_type.dart';
import 'package:sreyastha_gps/app/modules/add_marker/controllers/location_marker_controller.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_item.dart';

class LocationMarkerInput extends StatelessWidget {
  LocationMarkerInput(
      { //required this.markerType,
      required this.markerItem,
      required this.updateMarker,
      Key? key})
      : super(key: key);

  ///the id of the marker has already been created. We only need to update
  ///the marker
  final MarkerItem markerItem;

  ///To change the style of the form, we need to know the type of marker input
  //final MarkerType markerType;

  ///this function will update the marker in the marker list
  final Function(MarkerItem) updateMarker;

  @override
  Widget build(BuildContext context) {
    ///form contains all the input data associated with the marker
    return GetX<LocationMarkerController>(
      init: LocationMarkerController(
          editedMarkerItem: Rx<MarkerItem>(markerItem),
          updateMarker: updateMarker),
      builder: (controller) => AlertDialog(
        content: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,

            ///to prevent the app to take input without showing pixel overflow error
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      hintText: "ISM canteen",
                      labelText: "Enter marker name",
                    ),
                    textInputAction: TextInputAction.next,
                    initialValue: controller.editedMarkerItem.value.name,
                    validator: (value) {
                      ///TODO: remember to check whether the name of the
                      ///marker is unique or not
                      if (value == null || value.isEmpty) {
                        return "Name cannot be left empty";
                      }
                    },
                    onFieldSubmitted: (value) {
                      ///move to latitude input field
                      FocusScope.of(context)
                          .requestFocus(controller.latitudeFocusNode);
                    },
                    onSaved: (name) {
                      controller.editedMarkerItem.value.name = name!;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          ///disables the input area
                          //enabled: markerType == MarkerType.enterLocation,
                          enabled:
                              controller.editedMarkerItem.value.markerType ==
                                  MarkerType.enterLocation,
                          //assigning the focus node with a text input
                          focusNode: controller.latitudeFocusNode,
                          decoration: InputDecoration(
                            hintText: "26.3456",
                            labelText: "Enter latitude",
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          initialValue:
                              controller.editedMarkerItem.value.markerType ==
                                      MarkerType.enterLocation
                                  ? ""
                                  : controller.editedMarkerItem.value.location
                                      .location.latitude
                                      .toStringAsFixed(6),
                          validator: (latitude) {
                            if (latitude == null || latitude.isEmpty)
                              return "cannot be empty";

                            ///checks whether the number is decimal or not
                            if (double.tryParse(latitude) == null)
                              return "Enter number";

                            ///whether it lies between -90 to 90
                            if (double.parse(latitude) >= 90 &&
                                double.parse(latitude) <= -90)
                              return "Enter latitude";
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(controller.longitudeFocusNode);
                          },
                          onSaved: (latitude) {
                            if (latitude != null)
                              controller.editedMarkerItem.value.location
                                      .location.latitude =
                                  double.parse(latitude).toPrecision(6);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextFormField(
                          ///disables the input area
                          //enabled: markerType == MarkerType.enterLocation,
                          enabled:
                              controller.editedMarkerItem.value.markerType ==
                                  MarkerType.enterLocation,
                          //assigning the focus node with a text input
                          focusNode: controller.longitudeFocusNode,
                          validator: (longitude) {
                            if (longitude == null || longitude.isEmpty)
                              return "cannot be empty";

                            ///checks whether the number is decimal or not
                            if (double.tryParse(longitude) == null)
                              return "Enter a number";

                            ///whether it lies between -90 to 90
                            if (double.parse(longitude) >= 180 &&
                                double.parse(longitude) <= -180)
                              return "Enter longitude";
                          },
                          onSaved: (longitude) {
                            if (longitude != null)
                              controller.editedMarkerItem.value.location
                                      .location.longitude =
                                  double.parse(longitude).toPrecision(6);
                          },
                          decoration: InputDecoration(
                            hintText: "26.3456",
                            labelText: "Enter longitude",
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          initialValue:
                              controller.editedMarkerItem.value.markerType ==
                                      MarkerType.enterLocation
                                  ? ""
                                  : controller.editedMarkerItem.value.location
                                      .location.longitude
                                      .toStringAsFixed(6),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(controller.descriptionFocusNode);
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "The location is of ISM canteen",
                      labelText: "Enter Description",
                    ),
                    focusNode: controller.descriptionFocusNode,
                    initialValue: controller.editedMarkerItem.value.description,
                    validator: (description) {
                      if (description == null) return "Enter a description";

                      if (description.isEmpty)
                        return "Enter a description about the marker";
                      if (description.length > 50)
                        return "Kindly shorten the description";
                    },

                    ///Enter wont work as it adds new line
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,

                    onSaved: (description) {
                      controller.editedMarkerItem.value.description =
                          description;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.saveForm(context),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: active,
              ),
              child: Text(
                "Submit",
                style: GoogleFonts.poppins(color: light),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
