import 'package:geolocator/geolocator.dart';

enum RecordProfile {
  precise,
  general,
  powerSaving,
}

///record profile as strings
String getRecordProfileAsString(RecordProfile profile) {
  switch (profile) {
    case RecordProfile.precise:
      return "Precise";
    case RecordProfile.general:
      return "General";
    case RecordProfile.powerSaving:
      return "Power Saving";
  }
}

///convert string to record profile
RecordProfile getRecordProfileFromString(String profile) {
  switch (profile) {
    case "Precise":
      return RecordProfile.precise;
    case "General":
      return RecordProfile.general;
    case "Power Saving":
      return RecordProfile.powerSaving;
    default:
      return RecordProfile.precise;
  }
}

///provided the record profile we can find the location accuracy
LocationAccuracy getLocationAccuracyFromRecordProfile(RecordProfile profile) {
  switch (profile) {
    case RecordProfile.general:
      return LocationAccuracy.medium;
    case RecordProfile.precise:
      return LocationAccuracy.bestForNavigation;
    case RecordProfile.powerSaving:
      return LocationAccuracy.low;
  }
}

///it will provide the map of record profile and its content
Map<String, String> getRecordProfileForDisplay(RecordProfile profile) {
  switch (profile) {
    case RecordProfile.general:
      return {
        "General":
            "Frequency: 1 second, Accuracy: Location is accurate within a distance of 50m to 100m in android "
      };
    case RecordProfile.powerSaving:
      return {
        "Power Saving":
            "Frequency: 5 second, Accuracy: Location is accurate within a distance of 200m to 500m in android "
      };
    case RecordProfile.precise:
      return {
        "Precise":
            "Frequency: 1 second, Accuracy: Location is accurate within a distance of 0m to 20m in android "
      };
  }
}
