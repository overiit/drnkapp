import 'package:drnk/components/section_title.dart';
import 'package:drnk/components/settings/feedback.dart';
import 'package:drnk/components/settings/preference_liquids.dart';
import 'package:drnk/components/settings/profile_sex.dart';
import 'package:drnk/components/settings/profile_weight.dart';
import 'package:drnk/components/settings/reset.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/fns.dart';
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
  PreferenceModel preferenceModel = Get.find();
  List<Widget> buildMainSettings() {
    return [
      const SectionTitle(title: "User Profile"),
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
                openWidgetPopup(context, const ProfileSexSettings());
              },
            ),
          ),
        ],
      ),
      // const SectionTitle(title: "Preferences"),
      // buildSettingsContainer(
      //   children: [
      //     GetBuilder<PreferenceModel>(
      //       builder: (preferenceModel) => buildSettingsItem(
      //         icon: Icons.water_drop_outlined,
      //         title: "Liquid Unit",
      //         preview: preferenceModel.liquidUnit.toString().split(".")[1],
      //         onTap: () {
      //           openWidgetPopup(context, PreferenceLiquids());
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      const SectionTitle(title: "Privacy & Legal"),
      buildSettingsContainer(
        children: [
          Obx(() {
            return buildSettingsItem(
              icon: Icons.trending_up,
              title: "Event Logs",
              subtitle: "We use this data to improve the app",
              enabled: preferenceModel.trackingEnabled,
              onTap: () {
                preferenceModel.trackingEnabled =
                    !preferenceModel.trackingEnabled;
              },
            );
          }),
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
      const SectionTitle(title: "Other"),
      buildSettingsContainer(
        children: [
          buildSettingsItem(
            icon: Icons.feedback_outlined,
            title: "Feedback",
            isLink: true,
            onTap: () {
              openWidgetPopup(context, const FeedbackForm());
            },
          ),
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
    String? subtitle,
    Color color = Colors.white,
    bool isLink = false,
    bool? enabled,
    String? preview,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      splashColor: enabled != null ? Colors.transparent : null,
      overlayColor: enabled != null
          ? MaterialStateProperty.all(Colors.transparent)
          : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(
            vertical: subtitle != null ? 13 : 16, horizontal: 15),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w400, color: color),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: color.withOpacity(.5),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              preview ?? "",
              style: TextStyle(color: Colors.white.withOpacity(.65)),
            ),
            if (isLink) ...[
              const SizedBox(width: 5),
              Icon(Icons.chevron_right, color: color)
            ] else if (enabled != null) ...[
              const SizedBox(width: 5),
              SizedBox(
                height: 24,
                child: Transform.translate(
                  offset: const Offset(15, 0),
                  child: Transform.scale(
                    scale: 1,
                    child: Switch(
                      value: enabled,
                      activeColor: color,
                      onChanged: (value) {
                        onTap();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
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
