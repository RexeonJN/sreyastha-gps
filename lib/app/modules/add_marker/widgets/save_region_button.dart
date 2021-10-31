import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class SaveRegionButton extends StatelessWidget {
  SaveRegionButton({
    Key? key,
  }) : super(key: key);

  final Rx<String> fileName = "".obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _saveFile(BuildContext context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(fileName.value);
      Navigator.of(context).pop();
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
                      labelText: "Name of the region",
                      errorStyle: TextStyle(color: Colors.red)),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Please enter a name";
                    if (value.contains(" "))
                      return "Seperate names using - or _";
                    if (value.length >= 20)
                      return "Dont mention detailed file/region";
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
