import 'package:sreyastha_gps/app/data/enums/feature.dart';

class FileDetails {
  final String filename;
  final DateTime created;
  final Feature feature;
  final String path;

  FileDetails({
    required this.filename,
    required this.created,
    required this.feature,
    required this.path,
  });
}
