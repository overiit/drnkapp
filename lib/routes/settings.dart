import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/routes/welcome.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) updateUserProfile;

  const Settings(
      {super.key, required this.userProfile, required this.updateUserProfile});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  late Weight weight;
  late Gender gender;

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
        ],
      ),
    );
  }
}
