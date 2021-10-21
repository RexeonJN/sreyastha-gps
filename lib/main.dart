import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/data/controllers/custom_map_controller.dart';

import 'app/core/themes/colors.dart';
import 'app/data/controllers/gps_location_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  Get.put(GpsLocationController());
  Get.put(CustomMapController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        primaryColor: light,
        accentColor: active,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: dark),
      ),
    );
  }
}
