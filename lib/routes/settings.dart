import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  late Weight weight;
  late Sex sex;
  bool changed = false;

  @override
  void initState() {
    super.initState();
    UserProfileModel userProfileModel = Get.find();

    weight = userProfileModel.weight;
    sex = userProfileModel.sex;
  }

  List<Widget> buildMainSettings() {
    return [
      buildSettingsTitle("User Profile"),
      buildSettingsContainer(
        children: [
          buildSettingsItem(
            icon: Icons.heart_broken_outlined,
            title: "Your Weight",
            preview: "115kg",
            onTap: () {
              Get.toNamed("/settings/profile/weight");
            },
          ),
          buildSettingsItem(
            icon: Icons.wine_bar,
            title: "Your Sex",
            preview: "Male",
            onTap: () {
              Get.toNamed("/settings/profile/sex");
            },
          ),
        ],
      ),
      buildSettingsTitle("Preferences"),
      buildSettingsContainer(
        children: [
          buildSettingsItem(
            icon: Icons.water_drop_outlined,
            title: "Liquids",
            preview: "ML",
            onTap: () {
              Get.toNamed("/settings/preferences/liquids");
            },
          ),
        ],
      ),
      buildSettingsTitle("Legal"),
      buildSettingsContainer(
        children: [
          buildSettingsItem(
            icon: Icons.gavel_outlined,
            title: "Terms",
            onTap: () {
              Get.toNamed("/terms");
            },
          ),
        ],
      ),
      buildSettingsTitle("Other"),
      buildSettingsContainer(
        children: [
          buildSettingsItem(
            icon: Icons.delete_outline,
            title: "Reset app",
            onTap: () {
              Get.toNamed("/reset");
            },
          ),
        ],
      ),
    ];
  }

  Widget buildSettingsTitle(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
              color: Colors.white.withOpacity(.5),
            ),
          ),
        ],
      ),
    );
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
            Text(
              preview ?? "",
              style: TextStyle(color: Colors.white.withOpacity(.65)),
            ),
            const SizedBox(width: 5),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildMainSettings()),
    );
  }
}
