import 'package:get/get.dart';

import 'package:sreyastha_gps/app/modules/add_marker/bindings/add_marker_binding.dart';
import 'package:sreyastha_gps/app/modules/add_marker/views/add_marker_view.dart';
import 'package:sreyastha_gps/app/modules/home/bindings/home_binding.dart';
import 'package:sreyastha_gps/app/modules/home/views/home_view.dart';
import 'package:sreyastha_gps/app/modules/settings/bindings/settings_binding.dart';
import 'package:sreyastha_gps/app/modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_MARKER,
      page: () => AddMarkerView(),
      binding: AddMarkerBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}