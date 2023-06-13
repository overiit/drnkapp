import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/routes/welcome.dart';
import 'package:drnk/store/drinks.dart';
import 'package:drnk/store/user_profile.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile?) updateUserProfile;

  const Settings(
      {super.key, required this.userProfile, required this.updateUserProfile});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  late Weight weight;
  late Gender gender;
  bool resetAPP = false;

  @override
  void initState() {
    super.initState();
    weight = widget.userProfile.weight;
    gender = widget.userProfile.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          WelcomeForm(
            gender: gender,
            updateGender: (gender) {
              setState(() {
                this.gender = gender;
              });
            },
            weight: weight,
            updateWeight: (weight) {
              setState(() {
                this.weight = weight;
              });
            },
            title: false,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: BetterButton(
                  "SAVE",
                  onPressed: () {
                    widget.updateUserProfile(
                      UserProfile(gender: gender, weight: weight),
                    );
                  },
                  color: Colors.white,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (!resetAPP)
            Row(
              children: [
                Expanded(
                  child: BetterButton(
                    "Reset App",
                    onPressed: () {
                      setState(() {
                        resetAPP = true;
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
                        resetAPP = false;
                        widget.updateUserProfile(null);
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
                        resetAPP = false;
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
