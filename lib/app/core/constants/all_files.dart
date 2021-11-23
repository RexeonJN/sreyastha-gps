import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

///earlier this was the syntax. It is kept if any future error arrises
///key for the file is the pathname of the file saved in the map
///{{"Tracks":{"/path":FileDetails(),"/path2":FileDetails()}}}

///key for the file is the pathname of the file saved in the map
/// {
///   "Markers":{
///     "/pathname1":{
///       "filename":FileDetails.name,
///       "feature":FileDetails.feature,
///       "created":FileDetails.created,
///       "path":"/pathname1"
///     },
///     .....
///   },
/// "Tracks":...
///}
Map<String, Map<String, Map<String, dynamic>>> ALL_SAVED_FILES_FROM_THE_APP = {
  "Markers": {},
  "Routes": {},
  "Tracks": {},
};

///this has to be called whenever a new item is added to the list of files
///so that it can update the shred preferences
void updateFileData() async {
  final _storagePrefs = await SharedPreferences.getInstance();
  _storagePrefs.setString(
      "allSavedFiles", json.encode(ALL_SAVED_FILES_FROM_THE_APP));
}

///this is to called whenever the app relaunches to load all the files
///previously stored
void retrieveFileData() async {
  final _storagePrefs = await SharedPreferences.getInstance();

  ///contains the userData having token
  if (!_storagePrefs.containsKey("allSavedFiles")) {
    ALL_SAVED_FILES_FROM_THE_APP = {
      "Markers": {},
      "Routes": {},
      "Tracks": {},
    };
    return;
  }
  final extractedFilesInfo = _storagePrefs.getString("allSavedFiles")!;

  ///entire process is required to convert the datatype gradually
  final tempValue = json.decode(extractedFilesInfo) as Map<String, dynamic>;
  final tempValue2 = {
    "Markers": tempValue["Markers"] as Map<String, dynamic>,
    "Routes": tempValue["Routes"] as Map<String, dynamic>,
    "Tracks": tempValue["Tracks"] as Map<String, dynamic>
  };
  ALL_SAVED_FILES_FROM_THE_APP = {
    "Markers": tempValue2["Markers"]!.map(
      (key, value) => MapEntry(key, value as Map<String, dynamic>),
    ),
    "Routes": tempValue2["Routes"]!.map(
      (key, value) => MapEntry(key, value as Map<String, dynamic>),
    ),
    "Tracks": tempValue2["Tracks"]!.map(
      (key, value) => MapEntry(key, value as Map<String, dynamic>),
    ),
  };
}
