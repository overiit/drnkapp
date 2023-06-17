import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:drnk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSexSettings extends StatelessWidget {
  const ProfileSexSettings({super.key});

  @override
  Widget build(BuildContext context) {
    UserProfileModel userProfileModel = Get.find();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: Sex.values
          .map(
            (sex) => ListTile(
              title: Text(capitalize(sex.toString().split(".")[1])),
              leading:
                  Icon(userProfileModel.sex == sex ? Icons.male : Icons.female),
              trailing:
                  userProfileModel.sex == sex ? const Icon(Icons.check) : null,
              onTap: () {
                userProfileModel.sex = sex;
                userProfileModel.update();
                Get.back();
              },
            ),
          )
          .toList(),
    );
  }
}
