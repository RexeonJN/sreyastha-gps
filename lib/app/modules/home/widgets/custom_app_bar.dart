import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/data/controllers/auth_controller.dart';
import 'package:sreyastha_gps/app/data/enums/feature.dart';

import 'package:sreyastha_gps/app/routes/app_pages.dart';

import '/app/core/themes/colors.dart';

enum HomePageOptions {
  about,
  settings,
  contact,
}

String homePageOptionsAsStrings(HomePageOptions options) {
  switch (options) {
    case HomePageOptions.about:
      return "About Us";
    case HomePageOptions.settings:
      return "Settings";
    case HomePageOptions.contact:
      return "Contact Us";
  }
}

class HomePageAppBar extends StatelessWidget {
  final Function _openDrawer;

  HomePageAppBar(this._openDrawer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          _homePageHeading(context, _openDrawer),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  getListOfFeatures().map((act) => _selectAction(act)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _homePageHeading(BuildContext context, Function _openDrawer) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _openDrawer(),
            icon: Icon(
              Icons.menu,
              color: active,
            ),
          ),

          ///this part is simply used to run the autologging function when
          ///the app launches. Various middlewares can be used to improve the
          ///structure but is not done at the moment
          GetX<AuthController>(
            builder: (controller) {
              return !controller.isAuth.value
                  ? FutureBuilder(
                      builder: (ctx, snapshot) {
                        return Text(
                          "Sreyastha GPS",
                          style: GoogleFonts.poppins(color: active),
                          textScaleFactor: 1.1,
                        );
                      },
                      future: controller.tryAutoLogging(),
                    )
                  : Text(
                      "Sreyastha GPS",
                      style: GoogleFonts.poppins(color: active),
                      textScaleFactor: 1.1,
                    );
            },
          ),

          PopupMenuButton<HomePageOptions>(
            itemBuilder: (context) {
              return <PopupMenuEntry<HomePageOptions>>[
                PopupMenuItem(
                  child: Text(homePageOptionsAsStrings(HomePageOptions.about)),
                  value: HomePageOptions.about,
                ),
                PopupMenuItem(
                  child:
                      Text(homePageOptionsAsStrings(HomePageOptions.settings)),
                  value: HomePageOptions.settings,
                ),
                PopupMenuItem(
                  child:
                      Text(homePageOptionsAsStrings(HomePageOptions.contact)),
                  value: HomePageOptions.contact,
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case HomePageOptions.about:
                  Get.toNamed(Routes.ABOUT);
                  break;
                case HomePageOptions.settings:
                  Get.toNamed(Routes.SETTINGS, arguments: 0);
                  break;
                case HomePageOptions.contact:
                  Get.toNamed(Routes.CONTACT_US);
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _selectAction(String _action) {
    return Container(
      child: Chip(
        label: InkWell(
          onTap: () {
            switch (_action) {
              case "Marker":
                Get.toNamed(Routes.ADD_MARKER);
                break;
              case "Route":
                Get.toNamed(Routes.ADD_ROUTE);
                break;
              case "Track":
                Get.toNamed(Routes.ADD_TRACK);
                break;
            }
          },
          child: _action != "Marker"
              ? Text("Add " + _action)
              : Text("Save Location"),
        ),
        backgroundColor: light,
        elevation: 2,
      ),
    );
  }
}
