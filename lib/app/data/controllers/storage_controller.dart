import 'package:get/get.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_list.dart';

class StorageController extends GetxController {
  static StorageController instance = Get.find();

  ///a marker list is instantiated to hold all the markers in a list
  ///instead of creating it in add marker controller, we are creating it in
  ///storage controller because it can be accessed by entire app
  MarkerList markerList = MarkerList();
}
