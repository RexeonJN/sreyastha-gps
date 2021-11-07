import 'package:sreyastha_gps/app/data/models/file_details.dart';

///key for the file is the pathname of the file saved in the map
///{{"Tracks":{"/path":FileDetails(),"/path2":FileDetails()}}}
Map<String, Map<String, FileDetails>> ALL_FILES = {
  "Markers": {},
  "Routes": {},
  "Tracks": {},
};
