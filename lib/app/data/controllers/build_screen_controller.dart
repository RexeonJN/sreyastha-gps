import 'dart:async';

import 'package:get/get.dart';

class BuildScreenController extends GetxController {
  static BuildScreenController instance = Get.find();

  Timer? _timer;

  Rx<int> _globalCounter = Rx<int>(0);

  Rx<int> get globalCounter {
    if ((_timer != null && !_timer!.isActive) || _timer == null) {
      _timer = Timer(Duration(seconds: 1), () {
        _globalCounter.value++;
      });
    }
    return _globalCounter;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
