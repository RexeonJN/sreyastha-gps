import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class CurrentLocationMarkerButton extends StatelessWidget {
  const CurrentLocationMarkerButton({
    Key? key,
    required this.locationFunction,
    required this.currentlyMarkingGetter,
    required this.currentlyMarkingSetter,
  }) : super(key: key);

  final Function locationFunction;
  final Function currentlyMarkingSetter;
  final Function currentlyMarkingGetter;

  ///a dialog is shown which provides user an option to choose whether
  ///he wants to plot using the current location or he wants to make the location
  ///more accurate
  void _dialogForCurrentLocation(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "If you are a premium member, then you make the location more accurate by recording it for some time. The more time you record the current location, the more accurate it becomes",
          ),
          actions: [
            ///this button will be used to record the current location with
            ///whatever the accuracy we want
            TextButton(
              onPressed: () {
                if (!currentlyMarkingGetter()) {
                  locationFunction(false);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Mark with current accuracy"),
            ),

            ///this button will be used to average out the current location
            ///and will be shown if the user is logged in
            TextButton(
              onPressed: !authController.isAuth.value
                  ? () {}
                  : () {
                      if (!currentlyMarkingGetter()) {
                        currentlyMarkingSetter(true);
                      } else {
                        currentlyMarkingSetter(false);
                        locationFunction(true);
                        Navigator.of(context).pop();
                      }
                    },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      !authController.isAuth.value ? Colors.blueGrey : active,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow),
                    Text(
                      "Make more accurate",
                      style: GoogleFonts.poppins(color: light),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      bottom: MediaQuery.of(context).size.height * 0.5,
      child: InkWell(
        onTap: () {
          _dialogForCurrentLocation(context);
        },
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: active,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(1, 1),
                color: Colors.grey,
              )
            ],
          ),
          child: Icon(Icons.location_on, color: light),
        ),
      ),
    );
  }
}
