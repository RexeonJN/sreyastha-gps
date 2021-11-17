import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/routes/app_pages.dart';

import '/app/global_widgets/map_container.dart';
import '/app/core/themes/colors.dart';
import '/app/global_widgets/drawer_widgets/side_menu.dart';
import '../widgets/custom_app_bar.dart';
import '../controllers/home_controller.dart';

enum Actions { marker, track, route }

class IconNavigate {
  final IconData? icon;
  final void Function()? onPressed;
  final Color color;

  IconNavigate(this.icon, this.color, this.onPressed);
}

///Home view contains the main screen in which there are buttons to navigate
///to the marker page, track page and route page
///Only this screen contains the drawer. All the other screens doesnt contain
///the drawer or the bottom navigation bar.

class HomeView extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: SideNav(
          scaffoldKey: _scaffoldKey,
        ),
      ),
      body: Obx(
        () => controller.currentLocation.value != null
            ? Stack(
                children: [
                  MapContainer(
                    controller,
                    routeType: "Home",
                  ),
                  HomePageAppBar(_openDrawer),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: _bottomAppBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: FloatingActionButton(
        ///if there are more than two floating action buttons then there is a
        ///conflict in the hero tag
        backgroundColor: active,
        heroTag: null,
        onPressed: () {
          controller.moveToCurrentLocation();
        },
        child: const Icon(Icons.gps_fixed, color: Colors.white),
      ),
    );
  }

  /// This is the bottom navigation shown in the bottom of the home screen
  Widget _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width,
        color: light,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconNavigate(Icons.save, active, () {
              Get.toNamed(Routes.SAVED, arguments: 0);
            }),
            IconNavigate(Icons.settings, active, () {
              Get.toNamed(Routes.SETTINGS, arguments: 0);
            }),
            IconNavigate(Icons.person, active, () {
              Get.toNamed(Routes.PROFILE);
            }),

            /// this is present only to create an even distribution of buttons.
            /// in its place a floating action button will be shown.
            IconNavigate(Icons.settings, light, () {}),
          ]
              .map(
                (icon) => IconButton(
                  onPressed: icon.onPressed,
                  icon: Icon(icon.icon, color: icon.color),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
