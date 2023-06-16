import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SettingOption {
  ProfileWeight,
  ProfileSex,
  PreferenceWeight,
  PreferenceLiquid,
  Terms,
  Reset
}

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  late Weight weight;
  late Sex sex;
  bool changed = false;
  bool resetApp = false;

  SettingOption? currentSetting;

  @override
  void initState() {
    super.initState();
    UserProfileModel userProfileModel = Get.find();

    weight = userProfileModel.weight.value;
    sex = userProfileModel.sex.value;
  }

  List<Widget> buildMainSettings() {
    return [
      buildSettingsTitle("User Profile"),
      buildSettingsContainer(
        [
          buildSettingsItem(
            icon: Icons.heart_broken_outlined,
            title: "Your Weight",
            preview: "115kg",
            onTap: () {
              setState(() {
                currentSetting = SettingOption.ProfileWeight;
              });
            },
          ),
          buildSettingsItem(
            icon: Icons.wine_bar,
            title: "Your Sex",
            preview: "Male",
            onTap: () {
              setState(() {
                currentSetting = SettingOption.ProfileSex;
              });
            },
          ),
        ],
      ),
      buildSettingsTitle("User Profile"),
      buildSettingsContainer(
        [
          buildSettingsItem(
            icon: Icons.scale_outlined,
            title: "Weight",
            preview: "KG",
            onTap: () {
              setState(() {
                currentSetting = SettingOption.PreferenceWeight;
              });
            },
          ),
          buildSettingsItem(
            icon: Icons.water_drop_outlined,
            title: "Liquids",
            preview: "ML",
            onTap: () {
              setState(() {
                currentSetting = SettingOption.PreferenceLiquid;
              });
            },
          )
        ],
      ),
      buildSettingsTitle("Legal"),
      buildSettingsContainer(
        [
          buildSettingsItem(
            icon: Icons.gavel_outlined,
            title: "Terms",
            onTap: () {
              setState(() {
                currentSetting = SettingOption.Terms;
              });
            },
          ),
        ],
      ),
      buildSettingsTitle("Other"),
      buildSettingsContainer(
        [
          buildSettingsItem(
            icon: Icons.delete_outline,
            title: "Reset app",
            onTap: () {
              setState(() {
                currentSetting = SettingOption.Reset;
              });
            },
          ),
        ],
      ),
    ];
  }

  Widget buildSettingsTitle(String title) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
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

  Widget buildSettingsContainer(List<Widget> children) {
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
        children: currentSetting == null
            ? buildMainSettings()
            : [Text(currentSetting.toString())],
      ),
    );
  }

  Widget oldBuild(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            "Your Profile",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: BetterButton(
                  "SAVE",
                  onPressed: changed
                      ? () {
                          // widget.updateUserProfile(
                          //   UserProfile(sex: sex, weight: weight),
                          // );
                          Get.snackbar(
                            "Saved",
                            "Your settings have been saved.",
                            backgroundColor: Color(0xFF181818),
                            colorText: Colors.white,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 15),
                            padding: EdgeInsets.all(15),
                            borderRadius: 5,
                            borderWidth: 2,
                            borderColor: Colors.white.withOpacity(.2),
                            snackPosition: SnackPosition.TOP,
                          );
                        }
                      : null,
                  color: Colors.white.withOpacity(changed ? 1 : 0.5),
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: Color(0xFF000000)),
                ),
              ),
            ],
          ),
          if (!resetApp)
            Row(
              children: [
                Expanded(
                  child: BetterButton(
                    "Reset App",
                    onPressed: () {
                      setState(() {
                        resetApp = true;
                      });
                    },
                    style: const TextStyle(
                      color: Color(0xFFFF5F5F),
                      fontWeight: FontWeight.w800,
                    ),
                    color: Color(0x54FF5F5F),
                  ),
                ),
              ],
            )
          else ...[
            Text(
                "Are you sure you want to reset all settings and preferences?"),
            Row(
              children: [
                Expanded(
                  child: BetterButton(
                    "Yes",
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w800,
                    ),
                    color: Color(0xFFFF5F5F),
                    onPressed: () {
                      setState(() {
                        resetApp = false;
                        // widget.updateUserProfile(null);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: BetterButton(
                    "No",
                    color: Colors.white.withOpacity(.2),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        resetApp = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
