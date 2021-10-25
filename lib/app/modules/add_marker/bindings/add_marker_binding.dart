import 'package:get/get.dart';

import '../controllers/add_marker_controller.dart';

class AddMarkerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMarkerController>(
      () => AddMarkerController(),
    );
  }
}
