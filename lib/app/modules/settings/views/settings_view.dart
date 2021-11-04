import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';
import 'package:sreyastha_gps/app/modules/settings/views/load_csv_data_view.dart';
import 'package:sreyastha_gps/app/modules/settings/widgets/display_tab.dart';
import 'package:sreyastha_gps/app/modules/settings/widgets/record_tab.dart';
import 'package:sreyastha_gps/app/modules/settings/widgets/storage_tab.dart';

import '../controllers/settings_controller.dart';

///to check the csv accesibility all the file system is checked in settings page
///for now. This needs to be changed after the csv file system is implemented

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    ///this changes the index of the tab depending upon what is passed
    /// when navigating
    controller.changeIndex(Get.arguments);

    return DefaultTabController(
      initialIndex: controller.currentIndex.value,
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: light,
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(color: active),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: active,
              ),
            ),
            bottom: TabBar(
              tabs: ["Record", "Display", "Storage"]
                  .map((String name) => Tab(
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(color: active),
                        ),
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children: [
              RecordTab(),
              DisplayTab(),
              StorageTab(),
            ],
          )),
    );
  }

  ////function based on my understanding
  void createDirectories(BuildContext context) async {
    print((await getApplicationDocumentsDirectory()).path);
    print((await getApplicationSupportDirectory()).path);
    print((await getExternalStorageDirectory())!.path);
    List<String> paths = (await getExternalStorageDirectory())!.path.split("/");
    String newPath = '';
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }
    print(newPath);
    Directory directory = Directory(newPath + "/SreyathaGPS");
    if (await directory.exists()) {
      print("exists");
    } else {
      print(await directory.create(recursive: true));
    }
    List<List<String>> data = [
      ["No.", "Name", "Roll No."],
      ["1", "Kunal", "28"],
      ["2", "John", "22"],
      ["3", "Shanku", "52"]
    ];
    String csvData = ListToCsvConverter().convert(data);

    final String tempDirectory = (await getTemporaryDirectory()).path;
    final tempPath = "$tempDirectory/csv-${DateTime.now()}.csv";
    final path = "${directory.path}/attendance.csv";
    final File? file = File(tempPath);
    print("file : " + (await file!.exists()).toString());
    file.writeAsString(csvData);
    file.copy(path);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return LoadCsvDataView(
          path: tempPath,
        );
      }),
    );
  }

  ///function to generate and open a csv file
  ///this part is same as converting the markers into a list and then saving
  ///into csv
  generateCsv(BuildContext context) async {
    List<List<String>> data = [
      ["No.", "Name", "Roll No."],
      ["1", "Kunal", "28"],
      ["2", "John", "22"],
      ["3", "Shanku", "52"]
    ];

    ///List to csv converter converts the list into a csv.However the csv file
    ///has a list of data which are represneted as strings
    String csvData = ListToCsvConverter().convert(data);

    ///get the path of the application directory.Support path is the path
    ///which is inaccessible to normal user
    final String tempDirectory = (await getTemporaryDirectory()).path;

    ///creating a path where the csv will be stored
    final path = "$tempDirectory/csv-${DateTime.now()}.csv";
    print(path);

    ///create a file object in the concerned path
    final File? file = File(path);

    final String permanantDir = (await getApplicationDocumentsDirectory()).path;
    print(permanantDir);

    ///save the file in the disk
    file!.writeAsString(csvData);
    file.copy(await _saveCsv());

    ///navigate to a screen to display the result
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return LoadCsvDataView(
          path: path,
        );
      }),
    );
  }

  loadCsvFromStorage(BuildContext context) async {
    String? path;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    if (result != null) {
      path = result.files.first.path;
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return path != null ? LoadCsvDataView(path: path) : Scaffold();
      }));
    }
    return;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) return true;
    }
    return false;
  }

  Future<String> _saveCsv() async {
    Directory? directory;

    if (await _requestPermission(Permission.storage)) {
      directory = await getExternalStorageDirectory();
      String newPath = "";
      print(directory);
      List<String> paths = directory!.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath += "/RPSApp/";
      directory = Directory(newPath);
      if (await directory.exists()) {
        print("path" + directory.path);
      } else {
        await directory.create(recursive: true);
        print("path" + directory.path);
      }
    }
    return directory!.path;
  }
}
