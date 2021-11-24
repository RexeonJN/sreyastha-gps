import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/constants/all_files.dart';
import 'package:sreyastha_gps/app/modules/authentication/widgets/custom_input_field.dart';

import 'package:sreyastha_gps/app/modules/settings/controllers/settings_controller.dart';

class StorageTab extends GetView<SettingsController> {
  const StorageTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ///1. root folder
            ///switching folders removes all files in the application
            Obx(
              () => ListTile(
                title: Text(
                    "Parent Folder : ${controller.currentParentPath.value} "),
                subtitle: Text(
                  "This folder can be found in your internal storage wherever you have android folder. If it is a new folder then it will get created.",
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                            "Switching storage will delete all the files stored in the applications.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Form(
                                    key: controller.pathNameFormKey,
                                    child: AlertDialog(
                                      title: Text("Change folder"),
                                      content: Container(
                                        child: CustomTextInputField(
                                          labelText: "Enter folder name",
                                          hintText: "documents",
                                          inputType: TextInputType.text,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "The default marker name cannot be empty";
                                            }
                                            if (value.contains(" "))
                                              return "Seperate names using - or _";
                                            return null;
                                          },
                                          onSaved: (value) {
                                            if (value != null)
                                              controller.currentParentPath
                                                  .value = "/" + value;
                                          },
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            if (controller
                                                .changeParentPathName())
                                              Navigator.of(context).pop();
                                          },
                                          child: Text("Done"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Text("Continue"),
                            ),
                          ],
                        );
                      });
                },
              ),
            ),

            SizedBox(
              height: 20,
            ),

            ///2. storage Statistics
            ListTile(
              title: Text("Storage Files"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "total regions : ${ALL_SAVED_FILES_FROM_THE_APP["Markers"]!.length}"),
                  Text(
                      "total tracks : ${ALL_SAVED_FILES_FROM_THE_APP["Tracks"]!.length}"),
                  Text(
                      "total markers : ${ALL_SAVED_FILES_FROM_THE_APP["Routes"]!.length}"),
                ],
              ),
            ),

            SizedBox(height: 20),

            ///3.erase all the application contents
            ListTile(
              title: Text("Erase application contents"),
              subtitle: Text(
                "Removes all regions, tracks and routes stored in the application. Action cannot be undone. However, the files may remain in the folder which you need to remove externally.",
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Do you really want to delete all the items?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ALL_SAVED_FILES_FROM_THE_APP = {
                            "Markers": {},
                            "Routes": {},
                            "Tracks": {},
                          };
                          updateFileData();
                          Navigator.of(context).pop();
                          Get.back();
                        },
                        child: Text(
                          "Done",
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
