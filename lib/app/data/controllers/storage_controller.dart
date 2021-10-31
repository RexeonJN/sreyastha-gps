import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_list.dart';

class StorageController extends GetxController {
  static StorageController instance = Get.find();

  ///a marker list is instantiated to hold all the markers in a list
  ///instead of creating it in add marker controller, we are creating it in
  ///storage controller because it can be accessed by entire app
  MarkerList markerList = MarkerList();

  ///Directories to be accessed by the app
  Directory? mainDirectory;
  Directory? markerDirectory;
  Directory? trackDirectory;
  Directory? routeDirectory;

  ///All the folders and sub folders for the app are created before continuing
  ///further
  @override
  void onInit() {
    super.onInit();

    ///After 1 sec when the controller is ready, then it creates all the
    ///necessary folders required for all the files
    Future.delayed(Duration(seconds: 1)).then((value) async {
      if (await requestStoragePermissions(Permission.storage)) createFolders();
    });
  }

  ///Create folders
  void createFolders() async {
    ///create main folder
    List<String> paths = (await getExternalStorageDirectory())!.path.split("/");
    String newPath = '';
    for (int i = 1; i < paths.length; i++) {
      String folder = paths[i];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }

    ///Sreyastha GPS is in same directory in which there is Android folder
    mainDirectory = Directory(newPath + "/SreyathaGPS");
    _createDirectory(mainDirectory!);

    ///After the main folder is created, then all the sub folders are created
    markerDirectory = Directory(newPath + "/SreyathaGPS/Markers");
    _createDirectory(markerDirectory!);
    routeDirectory = Directory(newPath + "/SreyathaGPS/Routes");
    _createDirectory(routeDirectory!);
    trackDirectory = Directory(newPath + "/SreyathaGPS/Tracks");
    _createDirectory(trackDirectory!);
  }

  ///function to create one folder at a time
  void _createDirectory(Directory directory) async {
    if (await directory.exists()) {
      print("exists");
    } else {
      await directory.create(recursive: true);
    }
  }

  ///this is used to take permission from the user so as to make all the required
  ///folders and subfolders
  Future<bool> requestStoragePermissions(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) return true;
    }
    return false;
  }

  ///A function to convert all data to csv format
  String convertAllMarkerAsCsv(List<String> columnNames, List<String> values) {
    ///create List of List of strings which will eventually be converted to csv
    ///Data
    List<List<String>> rawData = [];

    rawData.add(columnNames);
    rawData.add(values);

    ///Convert the data to a csv data
    return ListToCsvConverter().convert(rawData);
  }

  ///A function to save all markers
  void saveAllMarkers(String filename) async {
    ///here the markerItem is a temporary marker which is stored in the list
    ///with its help we are naming the columns in our csv
    //////here we are expanding all the remaining marker data
    String csvMarkerData = convertAllMarkerAsCsv(
        markerList.markerItem!.nameOfAttributes,
        markerList.markerListAsList.expand((element) => element).toList());

    ///save the file to the marker folder
    final finalPath = markerDirectory!.path + "/$filename.csv";

    try {
      final File? file = File(finalPath);
      file!.writeAsString(csvMarkerData);
    } catch (e) {
      print(e);
    }
  }

  ///A function to delete all markers. Rather than deleting all markers after
  ///saving a region, it is better to give user the chance to decide
  void clearAllMarkers() {
    markerList.deleteAllMarker();
    update();
  }

  ///A function to read all markers from a csv
  void fetchMarkersFromCsv({String filename = "near"}) {
    loadingCsvData(markerDirectory!.path + "/$filename.csv");
  }

  ///To display the csv data we need to convert the csv into a list
  ///csv to list and then plot it
  void loadingCsvData(String path) async {
    ///open read creates a new stream of data for the csv
    final csvFile = new File(path).openRead();

    ///the data is first converted to a string and then it is converted to
    ///list
    List<List<dynamic>> allMarkerCsvList = await csvFile
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

    ///checking whether the heading column is of the same format as required
    for (String item in markerList.markerItem!.nameOfAttributes) {
      if (!allMarkerCsvList[0].contains(item)) {
        print("is not compatible");
        return;
      }
    }
    List<String> tempList = [];

    for (int i = 0; i < allMarkerCsvList[1].length; i++)
      tempList.add(allMarkerCsvList[1][i].toString());
    markerList.createMarkerFromList(tempList);
    update();
    print(markerList.markerListAsList);
  }
}
