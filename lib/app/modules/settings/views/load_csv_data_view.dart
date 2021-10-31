import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class LoadCsvDataView extends StatelessWidget {
  final String path;
  LoadCsvDataView({required this.path, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CSV data"),
      ),
      body: FutureBuilder(
        future: loadingCsvData(path),

        ///the builder gets one list at a time which means it takes one row at
        ///a time
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          ///print the data of one row received from the stream
          print(snapshot.data.toString());

          ///if the snapshot has data then it is displayed or else a circular
          ///progress indicator is shown in the middle of the screen
          ///
          ///this part is same as showing marker on the map
          ///remember to check whether the data is suitable to be plotted in the
          ///map. If it is not compatible then show a pop up that the file is
          ///wrong. This can be done while picking the files to be displayed
          ///before plotting on the map
          ///after this files are shown then there must be an option to select
          ///some or all the files to be displayed on the map
          ///
          ///the above mentioned thing will be done if the files are obtained
          /// from an external source. All the generated files will however be
          /// shown in the app itself. there will be no need to use pick files
          /// in such case
          return snapshot.hasData
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      children: snapshot.data!
                          .map((data) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(data[0].toString()),
                                    Text(data[1].toString()),
                                    Text(data[2].toString()),
                                  ],
                                ),
                              ))
                          .toList()),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ///this option will only be chosen if an external csv has to be plotted in
  /// the map
  pickFile() async {
    ///result hold all the files picked
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      ///grabs the first file from the list of all the picked files
      PlatformFile file = result.files.first;

      ///reads the file selected in the file
      final input = new File(file.path!).openRead();

      ///converts the csv file to a List of strings
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      ///display the data in the debug console
      print(fields);
    }
  }

  ///To display the csv data we need to convert the csv into a list
  ///csv to list and list to csv must be present inherent to the
  ///storage controller
  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    ///open read creates a new stream of data for the csv
    final csvFile = new File(path).openRead();

    ///the data is first converted to a string and then it is converted to
    ///list
    return await csvFile
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
  }
}
