import 'package:get/get.dart';

import '../controllers/add_track_controller.dart';

class AddTrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTrackController>(
      () => AddTrackController(),
    );
  }
}
