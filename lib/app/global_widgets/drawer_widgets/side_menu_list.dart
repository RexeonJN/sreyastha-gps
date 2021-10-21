import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class SideMenuItem {
  final String text;
  final Widget? icon;
  final Function? onTapItem;

  SideMenuItem({required this.text, this.icon, this.onTapItem});
}

class SideMenuList extends StatelessWidget {
  final height;
  final width;
  final GlobalKey<ScaffoldState> scaffoldKey;

  SideMenuList(
      {Key? key,
      required this.height,
      required this.width,
      required this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SideMenuItem> _categories = [
      SideMenuItem(
        text: "Home",
        onTapItem: () {
          //to simply close the drawer
          Navigator.pop(scaffoldKey.currentContext!);
        },
      ),
      SideMenuItem(
        text: "Saved Places",
        onTapItem: () {
          //to close drawer and then navigate to a screen
          Navigator.pop(scaffoldKey.currentContext!);
        },
      ),
      SideMenuItem(
          text: "Offers",
          onTapItem: () {
            Navigator.pop(scaffoldKey.currentContext!);
          }),
      SideMenuItem(
          text: "MemberShip",
          onTapItem: () {
            Navigator.pop(scaffoldKey.currentContext!);
          }),
      SideMenuItem(
        text: "Contact Us",
        onTapItem: () {
          Navigator.pop(scaffoldKey.currentContext!);
        },
      ),
    ];

    List<SideMenuItem> faqCategories = [
      SideMenuItem(
          text: "Terms and Conditions",
          onTapItem: () {
            Navigator.pop(scaffoldKey.currentContext!);
          }),
      SideMenuItem(
          text: "FAQ",
          onTapItem: () {
            Navigator.pop(scaffoldKey.currentContext!);
          }),
      SideMenuItem(
          text: "Privacy Policy",
          onTapItem: () {
            Navigator.pop(scaffoldKey.currentContext!);
          }),
    ];

    return Column(
      children: _categories
          .map<Widget>(
            (item) => InkWell(
              onTap: () {
                item.onTapItem!();
              },
              child: Container(
                height: height,
                width: width,
                padding: EdgeInsets.all(width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FittedBox(
                          child: Text(
                            item.text,
                          ),
                        ),
                      ],
                    ),
                    if (item.icon != null) FittedBox(child: item.icon),
                  ],
                ),
              ),
            ),
          )
          .toList()
            ..add(
              ExpandableNotifier(
                child: Expandable(
                  collapsed: ExpandableButton(
                    child: mainCategory("FAQ", Icon(Icons.add)),
                  ),
                  expanded: ExpandableButton(
                    child: Column(
                      children: [
                        mainCategory("FAQ", Icon(Icons.minimize)),
                        Column(
                          children: faqCategories
                              .map(
                                (e) => subCategory(
                                  e.text,
                                  e.onTapItem,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget mainCategory(String item, Icon? categoryIcon) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            child: Text(
              item,
            ),
          ),
          if (categoryIcon != null) FittedBox(child: categoryIcon)
        ],
      ),
    );
  }

  Widget subCategory(String item, Function? onTapItem) {
    return InkWell(
      onTap: onTapItem != null ? () => onTapItem() : null,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
            vertical: width * 0.04, horizontal: width * 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Text(
                item,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
