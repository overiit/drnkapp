import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSexSettings extends StatefulWidget {
  @override
  ProfileSexSettingsState createState() => ProfileSexSettingsState();
}

class ProfileSexSettingsState extends State<ProfileSexSettings> {
  Widget buildSexOption({
    required IconData icon,
    required String title,
    required bool selected,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      // splashColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            Icon(
              icon,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            if (selected)
              Icon(
                Icons.check,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProfileModel userProfileModel = Get.find<UserProfileModel>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Text(
                "What is your sex?".toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: Colors.white.withOpacity(.5),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSexOption(
                  icon: Icons.male,
                  title: "Male",
                  selected: userProfileModel.sex == Sex.male,
                  onTap: () {
                    userProfileModel.sex = Sex.male;
                    userProfileModel.update();
                  },
                ),
                buildSexOption(
                  icon: Icons.female,
                  title: "Female",
                  selected: userProfileModel.sex == Sex.female,
                  onTap: () {
                    userProfileModel.sex = Sex.female;
                    userProfileModel.update();
                  },
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
