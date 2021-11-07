import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/data/enums/feature.dart';
import 'package:sreyastha_gps/app/data/models/file_details.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

class FileCard extends StatelessWidget {
  FileCard({Key? key, required this.fileType, required this.fileDetails})
      : super(key: key);

  ///all the details of a file are present in this variable
  final FileDetails fileDetails;

  ///this distinguishes the operations depending upon the type of feature
  final String fileType;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => Row(
        children: [
          Container(
            height: constraints.maxHeight,
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.04,
              vertical: constraints.maxHeight * 0.05,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fileTitleWidget(constraints),
                    fileDetailRow(constraints),
                    Container(
                      width: constraints.maxWidth * 0.9,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Spacer(),
                          addButton(constraints, context),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///displays the name of the file
  ///here no distinguishing feature related to markers, tracks or routes are
  ///present
  Widget fileTitleWidget(BoxConstraints constraints) {
    return Container(
      height: constraints.maxHeight * 0.3,
      width: constraints.maxWidth * 0.8,
      padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.05),
      child: Text(fileDetails.filename,
          textAlign: TextAlign.left,
          textScaleFactor: 1.2,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  ///displays type of file and the date in which it was created
  ///here as well no distinguishing operation is required
  Widget fileDetailRow(BoxConstraints constraints) {
    return Container(
      height: constraints.maxHeight * 0.3,
      width: constraints.maxWidth * 0.9,
      padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Type :" + returnFeatureAsString(fileDetails.feature),
            textAlign: TextAlign.left,
            textScaleFactor: 1.1,
          ),
          SizedBox(
            width: 20,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 5,
            ),
            child: Text(
              " Created on :${fileDetails.created.day}-${fileDetails.created.month}-${fileDetails.created.year}",
              textAlign: TextAlign.left,
              textScaleFactor: 1,
              style: TextStyle(
                color: dark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///button which loads new region from saved files. It will also diplay a pop
  ///up to notify that all the markers in the current region will be lost
  Widget addButton(BoxConstraints constraints, BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(_warningText(fileType)),
            actions: [
              ///cancel is similar for all the features
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  ///clear all markers/track/route and then fetch
                  /// the file from csv
                  _loadFilesByFeatures(context);
                },
                child: Text("Okay"),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(3.0),
        height: constraints.maxHeight * 0.2,
        width: constraints.maxWidth * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: active,
        ),
        padding: EdgeInsets.all(
          constraints.maxHeight * (0.03),
        ),
        child: FittedBox(
          child: Text(
            "Show in map",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  ///pop for showing that file doesnt exists
  void _fileNotExists(BuildContext context, String featureTypeScreen) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: Text("The file doesn't exists. Check your device folder"),
        actions: [
          TextButton(
            onPressed: () {
              ///this pops the dialog box
              Get.back();

              ///this navigate back to add marker screen
              Get.back();
            },
            child: Text("Continue to " + featureTypeScreen + " screen."),
          ),
        ],
      ),
    );
  }

  ///to load files of different features
  void _loadFilesByFeatures(BuildContext context) {
    switch (fileType) {
      case "Markers":
        storageController.clearAllMarkers();
        storageController
            .fetchMarkersFromCsv(filename: fileDetails.filename)
            .then((value) {
          if (value) {
            ///this is done to reload all markers from a new file
            Get.back();
            Get.back();
            Future.delayed(Duration(milliseconds: 500))
                .then((value) => Get.toNamed(Routes.ADD_MARKER));
          } else {
            _fileNotExists(context, "save location");
          }
        });
        break;
      case "Tracks":
        storageController.trackItem.deleteTrackItem();
        storageController
            .fetchTrackFromCsv(filename: fileDetails.filename)
            .then((value) {
          if (value) {
            ///this is done to reload track from a new file
            Get.back();
            Get.back();
            Future.delayed(Duration(milliseconds: 500))
                .then((value) => Get.toNamed(Routes.ADD_TRACK));
          } else {
            _fileNotExists(context, "add track");
          }
        });
        break;
    }
  }
}

///returns what to display as warning
String _warningText(String type) {
  switch (type) {
    case "Markers":
      return "All the markers in your current region will be lost if they are not saved. If you want to load the new region and override the current region then continue or else cancel.";
    case "Tracks":
      return "Current track will be lost if it is not saved. If you want to load a new track and override the current track then continue or else cancel.";
    case "Routes":
      return "Current route will be lost if it is not saved. If you want to load new route and override the current route then continue or else cancel.";
    default:
      return "All the markers in your current region will be lost if they are not saved. If you want to load the new region and override the current region then continue or else cancel.";
  }
}
