import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreyastha_gps/app/data/enums/record_profile.dart';

Map<String, String> SETTINGS = {
  ///time interval is in seconds
  "timeInterval": "5",

  ///distance interval is in m
  "distanceInterval": "5",

  ///the marker name to be used while creating
  "defaultMarkerName": "Mark",

  ///file import folder name
  "parentPathName": "/SreyasthaGPS",

  ///record profile
  "recordProfile": getRecordProfileAsString(RecordProfile.precise),

  "corrections": "unabled"
};

///this has to be called whenever a settings is updated
///so that it can update the shared preferences
void updateSettingsData() async {
  final _settingsPrefs = await SharedPreferences.getInstance();
  _settingsPrefs.setString("settings", json.encode(SETTINGS));
}

///this is to called whenever the app relaunches to load all the settings
///previously stored
void retrieveSettingsData() async {
  final _settingsPrefs = await SharedPreferences.getInstance();

  ///contains the userData having token
  if (!_settingsPrefs.containsKey("settings")) {
    SETTINGS = {
      "timeInterval": "5",
      "distanceInterval": "5",
      "defaultMarkerName": "Mark",
      "parentPathName": "/SreyasthaGPS",
      "recordProfile": getRecordProfileAsString(RecordProfile.precise),
      "corrections": "unabled"
    };
    return;
  }
  final extractedSettingsInfo = _settingsPrefs.getString("settings")!;

  final extractedSettings =
      json.decode(extractedSettingsInfo) as Map<String, dynamic>;

  SETTINGS = {
    "timeInterval": extractedSettings["timeInterval"].toString(),
    "distanceInterval": extractedSettings["distanceInterval"].toString(),
    "defaultMarkerName": extractedSettings["defaultMarkerName"].toString(),
    "parentPathName": extractedSettings["parentPathName"].toString(),
    "recordProfile": extractedSettings["recordProfile"].toString(),
    "corrections": extractedSettings["corrections"].toString()
  };
}
