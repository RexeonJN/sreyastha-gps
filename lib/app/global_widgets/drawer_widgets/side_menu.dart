import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/data/controllers/auth_controller.dart';

import '/app/core/themes/colors.dart';
import '/app/global_widgets/drawer_widgets/side_menu_list.dart';

import 'drawer_components.dart';

class SideNav extends StatefulWidget {
  SideNav({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _SideNavState createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  bool _deliveryShow = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          var onLoginMessageTap = Text(
            !authController.isAuth.value
                ? "*In order to access premium features, you have to register and subscribe to a plan."
                : "You can now use accurate location button in save location page and add correction in settings.",
            textScaleFactor: 0.8,
          );
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                Container(
                  height: !_deliveryShow
                      ? constraints.maxHeight * 0.0705 * 2 +
                          MediaQuery.of(context).padding.top
                      : constraints.maxHeight * 0.0705 * 2 +
                          MediaQuery.of(context).padding.top +
                          constraints.maxHeight * 0.08,
                  width: constraints.maxWidth,
                  child: Column(
                    children: [
                      //Main Menu
                      Container(
                        height: MediaQuery.of(context).padding.top,
                        width: constraints.maxWidth,
                        color: active,
                      ),
                      authenticationOrWelcomeBar(constraints),

                      loginMessage(constraints),

                      _deliveryShow
                          ? Container(
                              height: constraints.maxHeight * 0.08,
                              width: constraints.minWidth,
                              padding: EdgeInsets.symmetric(
                                horizontal: constraints.minWidth * 0.15,
                                vertical: constraints.minHeight * 0.005,
                              ),
                              child: onLoginMessageTap,
                            )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.0025 * 2,
                  width: constraints.maxWidth,
                  color: Colors.black26,
                ),
                Container(
                  height: !_deliveryShow
                      ? constraints.maxHeight * (1 - 0.073 * 2) -
                          MediaQuery.of(context).padding.top
                      : constraints.maxHeight * (1 - 0.073 * 2 - 0.08) -
                          MediaQuery.of(context).padding.top,
                  width: constraints.maxWidth,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: SideMenuList(
                      height: constraints.maxHeight * 0.07,
                      width: constraints.maxWidth,
                      scaffoldKey: widget.scaffoldKey,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  InkWell loginMessage(BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        setState(() {
          _deliveryShow = !_deliveryShow;
        });
      },
      child: Container(
        height: constraints.maxHeight * 0.07,
        width: constraints.maxWidth,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(constraints.maxHeight * 0.015),
              width: constraints.maxWidth * 0.15,
              child: FittedBox(
                child: Icon(
                  Icons.account_box,
                  color: active,
                ),
              ),
            ),
            Container(
              width: constraints.maxWidth * 0.7,
              padding: EdgeInsets.all(constraints.maxHeight * 0.015),
              child: Obx(
                () => Text(
                  authController.isAuth.value
                      ? "You are a premium member"
                      : "Login for more features*",
                  softWrap: true,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(constraints.maxHeight * 0.015),
              width: constraints.maxWidth * 0.15,
              child: FittedBox(
                child: !_deliveryShow
                    ? Icon(
                        Icons.arrow_downward,
                        color: Colors.black54,
                      )
                    : Icon(
                        Icons.arrow_upward,
                        color: Colors.black54,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget authenticationOrWelcomeBar(BoxConstraints constraints) {
    return Container(
      color: active,
      height: constraints.maxHeight * 0.07,
      width: constraints.maxWidth,
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.12),
      child: GetX<AuthController>(
          builder: (controller) => controller.isAuth.value
              ? AuthenticationButton(
                  constraints: constraints,
                  displayText: "Log out ",
                  logout: true,
                )
              : FutureBuilder(
                  builder: (ctx, resultSnapshot) {
                    return resultSnapshot.data == false
                        ? Row(
                            children: [
                              AuthenticationButton(
                                constraints: constraints,
                                displayText: "Login",
                              ),
                              Spacer(),
                              AuthenticationButton(
                                constraints: constraints,
                                displayText: "Sign Up",
                                signup: true,
                              ),
                            ],
                          )
                        : AuthenticationButton(
                            constraints: constraints,
                            displayText: "Log out ",
                            logout: true,
                          );
                  },
                  future: controller.tryAutoLogging(),
                )),
    );
  }
}
