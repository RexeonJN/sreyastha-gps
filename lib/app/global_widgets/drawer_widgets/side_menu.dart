import 'package:flutter/material.dart';

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
        builder: (context, constraints) => Container(
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
                    Container(
                      color: active,
                      height: constraints.maxHeight * 0.07,
                      width: constraints.maxWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.12),
                      child: Row(
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
                      ),
                    ),

                    InkWell(
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
                              padding:
                                  EdgeInsets.all(constraints.maxHeight * 0.015),
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
                              padding:
                                  EdgeInsets.all(constraints.maxHeight * 0.015),
                              child: Text(
                                "Login for more features*",
                                softWrap: true,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.all(constraints.maxHeight * 0.015),
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
                    ),

                    _deliveryShow
                        ? Container(
                            height: constraints.maxHeight * 0.08,
                            width: constraints.minWidth,
                            padding: EdgeInsets.symmetric(
                              horizontal: constraints.minWidth * 0.15,
                              vertical: constraints.minHeight * 0.005,
                            ),
                            child: Text(
                              "*In order to access premium features, you have to register and subscribe to a plan",
                              textScaleFactor: 0.8,
                            ),
                          )
                        : Container(),
                    //membership

                    //shop by category
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
        ),
      ),
    );
  }
}
