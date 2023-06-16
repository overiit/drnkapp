import 'package:drnk/components/section_title.dart';
import 'package:drnk/components/settings/preference_liquids.dart';
import 'package:drnk/components/settings/profile_sex.dart';
import 'package:drnk/components/settings/profile_weight.dart';
import 'package:drnk/components/settings/reset.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:drnk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  List<Widget> buildMainSettings() {
    return [
      SectionTitle(title: "User Profile"),
      buildSettingsContainer(
        children: [
          GetBuilder<UserProfileModel>(
            builder: (userProfileModel) => buildSettingsItem(
              icon: Icons.scale,
              title: "Your Weight",
              preview: userProfileModel.weight.toApproxString(),
              onTap: () {
                openWidgetPopup(context, ProfileWeightSettings());
              },
            ),
          ),
          GetBuilder<UserProfileModel>(
            builder: (userProfileModel) => buildSettingsItem(
              icon:
                  userProfileModel.sex == Sex.male ? Icons.male : Icons.female,
              title: "Your Sex",
              preview:
                  capitalize(userProfileModel.sex.toString().split(".")[1]),
              onTap: () {
                openWidgetPopup(context, ProfileSexSettings());
              },
            ),
          ),
        ],
      ),
      SectionTitle(title: "Preferences"),
      buildSettingsContainer(
        children: [
          GetBuilder<PreferenceModel>(
            builder: (preferenceModel) => buildSettingsItem(
              icon: Icons.water_drop_outlined,
              title: "Liquid Unit",
              preview: preferenceModel.liquidUnit.toString().split(".")[1],
              onTap: () {
                openWidgetPopup(context, PreferenceLiquids());
              },
            ),
          ),
        ],
      ),
      SectionTitle(title: "Legal"),
      buildSettingsContainer(
        children: [
          buildSettingsItem(
            icon: Icons.gavel_outlined,
            title: "Terms & Conditions",
            isLink: true,
            onTap: () {
              Get.toNamed("/terms");
            },
          ),
        ],
      ),
      SectionTitle(title: "Other"),
      buildSettingsContainer(
        children: [
          buildSettingsItem(
            icon: Icons.delete_outline,
            title: "Reset app",
            color: Colors.redAccent,
            isLink: true,
            onTap: () {
              openWidgetPopup(context, ResetApp());
            },
          ),
        ],
      ),
    ];
  }

  Widget buildSettingsContainer({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(children: children),
    );
  }

  Widget buildSettingsItem({
    required IconData icon,
    required String title,
    Color color = Colors.white,
    bool isLink = false,
    String? preview,
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
              color: color,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w400, color: color),
            ),
            const Spacer(),
            Text(
              preview ?? "",
              style: TextStyle(color: Colors.white.withOpacity(.65)),
            ),
            if (isLink) ...[
              const SizedBox(width: 5),
              Icon(Icons.chevron_right, color: color)
            ],
          ],
        ),
      ),
    );
  }

  void openWidgetPopup(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: buildMainSettings(),
      ),
    );
  }
}
