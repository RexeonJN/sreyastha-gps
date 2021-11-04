import 'package:get/get.dart';

class SavedController extends GetxController {
  ///this is used to navigate to the concerned tab depending upon which index
  ///is required to be viewed
  final Rx<int> currentIndex = 0.obs;

  ///changes the index of the tab
  void changeIndex(int index) {
    currentIndex.value = index;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
