import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/constants/controllers.dart';
import 'package:sreyastha_gps/app/data/enums/record_profile.dart';
import 'package:sreyastha_gps/app/modules/authentication/widgets/custom_input_field.dart';

import 'package:sreyastha_gps/app/modules/settings/controllers/settings_controller.dart';

class RecordTab extends GetView<SettingsController> {
  const RecordTab({Key? key}) : super(key: key);

  void _changeSettingDialogBox(
      BuildContext context, String title, Widget innerContent,
      {Function? executeOnDone, Key? key}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Form(
        key: key,
        child: AlertDialog(
          title: Text(title),
          content: innerContent,
          actions: [
            TextButton(
              onPressed: () {
                if (executeOnDone != null) {
                  executeOnDone();
                }
              },
              child: Text("Done"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ///1.to change the time interval while creating a track
            Obx(
              () => _inputInDialogBoxOfSettings(context,
                  number: true,
                  key: controller.timeIntervalFormKey,
                  titleText:
                      "Time Interval : ${controller.timeInterval.value} sec",
                  subtitleText:
                      "If you are using time as interval while creating tracks, then points in track will be created after the set interval time.",
                  dialogBoxTitle: "Change Time Interval",
                  inputLabelText: "time interval",
                  inputHintText: "30",
                  executeOnDoneEditing: controller.updateTimeInterval,
                  typeOfSettings: "timeInterval"),
            ),

            ///2.to change the distance interval while creating a track
            Obx(
              () => _inputInDialogBoxOfSettings(context,
                  number: true,
                  key: controller.distanceIntervalFormKey,
                  titleText:
                      "Distance Interval : ${controller.distanceInterval.value} m",
                  subtitleText:
                      "If you are using distance as interval while creating tracks, then points in track will be created after the set distance.",
                  dialogBoxTitle: "Change Distance Interval",
                  inputLabelText: "distance interval",
                  inputHintText: "30",
                  executeOnDoneEditing: controller.updateDistanceInterval,
                  typeOfSettings: "distanceInterval"),
            ),

            _recordProfileSettings(context),

            ///4.to change the default marker name to be shown while creating a
            ///marker
            Obx(
              () => _inputInDialogBoxOfSettings(context,
                  key: controller.defaultMarkerFormKey,
                  titleText:
                      "Default Marker Name : ${controller.defaultMarkerName.value}",
                  subtitleText:
                      "This name will be used as a default name while creating a marker. It will be followed by a numeral as you keep adding more markers. For example, Mark1",
                  dialogBoxTitle: "Change Default Marker Name",
                  inputLabelText: "default marker name",
                  inputHintText: "Mark",
                  executeOnDoneEditing: controller.updateDefaultMarkerName,
                  typeOfSettings: "defaultMarkerName"),
            ),

            ///5.this is simply used to start the correction obtained from the net
            ListTile(
              onTap: () {
                if (authController.isAuth.value) {
                  if (controller.showIcons.value == "unabled") {
                    controller.switchCorrections("enabled");
                  } else {
                    controller.switchCorrections("unabled");
                  }
                } else
                  controller.switchCorrections("unabled");
              },
              title: Row(
                children: [
                  Text("Enable corrections"),
                  SizedBox(width: 30),
                  Obx(
                    () => Icon(
                      controller.showIcons.value == 'enabled'
                          ? Icons.wifi
                          : Icons.wifi_off,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                  "If you have taken a premium account then you can obtain correction from the server. This will make your locations more accurate."),
            )
          ],
        ),
      ),
    );
  }

  ///any settings which may have an input in dialog box
  Widget _inputInDialogBoxOfSettings(
    BuildContext context, {
    required Key key,
    required String titleText,
    required String subtitleText,
    required String dialogBoxTitle,
    required String inputLabelText,
    required String inputHintText,
    bool number = false,
    required Function executeOnDoneEditing,
    required String typeOfSettings,
  }) {
    return ListTile(
      title: Text(titleText),
      subtitle: Text(subtitleText),
      onTap: () {
        _changeSettingDialogBox(
            context,
            dialogBoxTitle,
            Container(
              child: CustomTextInputField(
                labelText: inputLabelText,
                hintText: inputHintText,
                inputType: !number ? TextInputType.text : TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "The default marker name cannot be empty";
                  }

                  if (number && int.tryParse(value) == null)
                    return "must be an integer";
                  if (int.tryParse(value) != null && int.tryParse(value)! < 5)
                    "enter value greater than 5";
                  return null;
                },
                onSaved: (value) {
                  if (value != null)
                    switch (typeOfSettings) {
                      case "defaultMarkerName":
                        controller.defaultMarkerName.value = value;
                        break;
                      case "timeInterval":
                        controller.timeInterval.value = value.toString();
                        break;
                      case "distanceInterval":
                        controller.distanceInterval.value = value.toString();
                        break;
                    }
                  ;
                },
              ),
            ), executeOnDone: () {
          if (executeOnDoneEditing()) Navigator.of(context).pop();
        }, key: key);
      },
    );
  }

  ///3.this is used to set the location accuracy
  Obx _recordProfileSettings(BuildContext context) {
    return Obx(
      () => ListTile(
        title: Text(
            "Location Accuracy : ${controller.recordProfileTextToShow.value}"),
        subtitle: Text(getRecordProfileForDisplay(getRecordProfileFromString(
                controller.recordProfileTextToShow.value))
            .values
            .first),
        onTap: () {
          _changeSettingDialogBox(
            context,
            "Choose Location Accuracy",
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  RecordProfile.precise,
                  RecordProfile.general,
                  RecordProfile.powerSaving
                ].map((profile) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                            getRecordProfileForDisplay(profile).keys.first),
                        subtitle: Text(
                            getRecordProfileForDisplay(profile).values.first),
                        onTap: () {
                          Navigator.of(context).pop();
                          controller.updateRecordProfile(profile);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
