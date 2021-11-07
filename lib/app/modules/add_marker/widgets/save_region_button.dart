import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/constants/all_files.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/data/models/file_details.dart';

class SaveRegionButton extends StatelessWidget {
  SaveRegionButton({
    Key? key,
  }) : super(key: key);

  final Rx<String> fileName = "".obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///if the form is validated, then it will save the file and get all data in
  ///filename variable. The name of the variable is used to store the file in
  ///the desired location
  void _saveFile(BuildContext context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop();

      ///check whether the filename already exists or not. If it exits
      /// then it gives user a chance to either skip it or override it
      final allSavedRegions = ALL_FILES['Markers']!.values;
      for (FileDetails singleFile in allSavedRegions) {
        if (fileName == singleFile.filename) {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(content: Text("Filename already exists"), actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  storageController.saveAllMarkers(fileName.value);
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
      storageController.saveAllMarkers(fileName.value);
    }
  }

  ///A pop up comes up whenever user wants to save all the markers
  ///On submitting the button, the data of all the markers are saved in the file
  ///This means that this button is directly connected to the storage controller
  ///and is not affected by any of the other controllers
  void _inputFileName(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Salt_Lake_City",
                      labelText: "Name of the region/file",
                      errorStyle: TextStyle(color: Colors.red)),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Please enter a name";
                    if (value.contains(" "))
                      return "Seperate names using - or _";
                    if (value.length >= 20)
                      return "Dont keep large file/region name";
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
                onPressed: () {},
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => _saveFile(context),
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

  ///A simple button as UI which opens up a dialog box to enter the filename
  ///and to save all the markers in the file
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 20,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _inputFileName(context);
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: light,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(1, 1),
                        color: Colors.grey)
                  ]),
              child: Row(
                children: [
                  Icon(
                    Icons.save,
                    color: active,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "save markers in this region",
                    style: TextStyle(
                      color: active,
                    ),
                    textScaleFactor: 1.1,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
