import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/constants/all_files.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/core/constants/settings.dart';
import 'package:sreyastha_gps/app/data/enums/record_profile.dart';

class SettingsController extends GetxController {
  ///this is used to navigate to the concerned tab depending upon which index
  ///is required to be viewed
  final Rx<int> currentIndex = 0.obs;

  ///variables for the record profile setting
  final Rx<String> recordProfileTextToShow = SETTINGS["recordProfile"]!.obs;

  ///variables for the corrections to show
  final Rx<String> showIcons = SETTINGS["corrections"]!.obs;

  ///variables for the default marker setting
  final Rx<String> defaultMarkerName = SETTINGS["defaultMarkerName"]!.obs;
  final GlobalKey<FormState> defaultMarkerFormKey = GlobalKey();

  ///variables for the time interval setting
  final Rx<String> timeInterval = SETTINGS["timeInterval"]!.obs;
  final GlobalKey<FormState> timeIntervalFormKey = GlobalKey();

  ///variables for the distance interval setting
  final Rx<String> distanceInterval = SETTINGS["distanceInterval"]!.obs;
  final GlobalKey<FormState> distanceIntervalFormKey = GlobalKey();

  ///variables to change the parent path in which the file will be stored
  final Rx<String> currentParentPath = SETTINGS["parentPathName"]!.obs;
  final GlobalKey<FormState> pathNameFormKey = GlobalKey();

  ///updates the record profile to the settings
  void updateRecordProfile(RecordProfile profile) {
    SETTINGS["recordProfile"] = getRecordProfileAsString(profile);
    recordProfileTextToShow.value = SETTINGS["recordProfile"]!;
    updateSettingsData();
  }

  ///update the corrections
  void switchCorrections(String status) {
    SETTINGS["corrections"] = status;
    showIcons.value = SETTINGS["corrections"]!;
    updateSettingsData();
  }

  bool changeParentPathName() {
    ///if validated, then save the form
    if (!pathNameFormKey.currentState!.validate()) {
      return false;
    }

    pathNameFormKey.currentState!.save();
    SETTINGS["parentPathName"] = currentParentPath.value;
    updateSettingsData();
    ALL_SAVED_FILES_FROM_THE_APP = {
      "Markers": {},
      "Routes": {},
      "Tracks": {},
    };
    updateFileData();
    storageController.createFolders();
    update();
    return true;
  }

  ///updates the default marker name to the settings
  bool updateDefaultMarkerName() {
    ///if validated, then save the form
    if (!defaultMarkerFormKey.currentState!.validate()) {
      return false;
    }

    defaultMarkerFormKey.currentState!.save();
    SETTINGS["defaultMarkerName"] = defaultMarkerName.value;
    updateSettingsData();
    update();
    return true;
  }

  ///updates the time interva in the settings
  bool updateTimeInterval() {
    ///if validated, then save the form
    if (!timeIntervalFormKey.currentState!.validate()) {
      return false;
    }

    timeIntervalFormKey.currentState!.save();
    SETTINGS["timeInterval"] = timeInterval.value;
    updateSettingsData();
    update();
    return true;
  }

  ///updates the distance interval in the settings
  bool updateDistanceInterval() {
    ///if validated, then save the form
    if (!distanceIntervalFormKey.currentState!.validate()) {
      return false;
    }

    distanceIntervalFormKey.currentState!.save();
    SETTINGS["distanceInterval"] = distanceInterval.value;
    updateSettingsData();
    update();
    return true;
  }

  ///changes the index of the tab
  void changeIndex(int index) {
    currentIndex.value = index;
    update();
  }
}
