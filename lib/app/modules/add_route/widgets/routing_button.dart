import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/constants/all_files.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/data/models/file_details.dart';

class RoutingButton extends StatelessWidget {
  RoutingButton(
      {required this.startCreating,
      required this.endCreating,
      required this.creationStatus,
      Key? key})
      : super(key: key);

  final Rx<bool> Function() creationStatus;
  final Function startCreating;
  final Function endCreating;

  final Rx<String> fileName = "".obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///A pop up comes up whenever user wants to end route and save the route
  ///On submitting the button, the data of the track is saved in the file
  ///This means that this button is directly connected to the storage controller
  ///and is not affected by any of the other controllers
  void _inputFileName(BuildContext context) async {
    await showDialog(

        ///this prevents user from dismissing the pop up without putting the file
        ///name
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Kolkata_to_hyderabad",
                      labelText: "Name of the Route",
                      errorStyle: TextStyle(color: Colors.red)),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Please enter a name";
                    if (value.contains(" "))
                      return "Seperate names using - or _";
                    if (value.length >= 20)
                      return "Dont keep large file/route name";
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) fileName.value = value;
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _saveFile(context);
                },
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
          );
        });
  }

  ///if the form is validated, then it will save the file and get all data in
  ///filename variable. The name of the variable is used to store the file in
  ///the desired location
  void _saveFile(BuildContext context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop();

      ///check whether the filename already exists or not. If it exits
      /// then it gives user a chance to either skip it or override it
      final allSavedRegions = ALL_FILES['Routes']!.values;
      for (FileDetails singleFile in allSavedRegions) {
        if (fileName == singleFile.filename) {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(content: Text("Filename already exists"), actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  storageController.saveRoute(fileName.value);
                },
                child: Text("Override it"),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Edit another name"),
              ),
            ]),
          );
          return;
        }
      }
      storageController.saveRoute(fileName.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      top: MediaQuery.of(context).size.height / 2.2,
      child: InkWell(
        onTap: () {
          if (!creationStatus().value) {
            startCreating();
          } else {
            endCreating();
            _inputFileName(context);
          }
        },
        //button looks similar to a floating action button
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: active,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(1, 1),
                    color: Colors.grey)
              ]),
          child:

              ///depending upon whether the track is recording the
              /// icon switches
              ///to track it obx is needed
              !creationStatus().value
                  ? Icon(
                      Icons.play_arrow,
                      color: light,
                    )
                  : Icon(
                      Icons.stop,
                      color: light,
                    ),
        ),
      ),
    );
  }
}
