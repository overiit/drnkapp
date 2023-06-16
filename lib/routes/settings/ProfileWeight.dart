import 'package:drnk/components/buttons/OutlinedTextField.dart';
import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:drnk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileWeightSettings extends StatefulWidget {
  @override
  _WeightSettingsState createState() => _WeightSettingsState();
}

class _WeightSettingsState extends State<ProfileWeightSettings> {
  bool changed = false;

  @override
  Widget build(BuildContext context) {
    UserProfileModel userProfileModel = Get.find();
    return Column(
      children: [
        const Row(
          children: [
            Text(
              "How much do you weigh?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: BetterTextField(
                isNumber: true,
                hintText:
                    "Your Weight in ${capitalize(userProfileModel.weight.unit.name)}",
                color: Colors.white,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                ),
                initialValue: userProfileModel.weight.amount.toString(),
                onChanged: (value) {
                  double? amount = double.tryParse(value);
                  if (amount != null) {
                    userProfileModel.weight = Weight(
                      amount: amount,
                      unit: userProfileModel.weight.unit,
                    );
                  } else {
                    userProfileModel.weight = Weight(
                      amount: 0,
                      unit: userProfileModel.weight.unit,
                    );
                  }
                },
                padding: 5,
              ),
            ),
            const SizedBox(width: 10),
            BetterButton(
              "KG",
              color: Colors.transparent,
              borderColor: Colors.white.withOpacity(
                  userProfileModel.weight.unit == WeightUnit.kg ? 1 : .5),
              style: TextStyle(
                color: Colors.white.withOpacity(
                    userProfileModel.weight.unit == WeightUnit.kg ? 1 : .5),
              ),
              onPressed: () {
                userProfileModel.weight = convertWeight(
                  userProfileModel.weight,
                  WeightUnit.kg,
                );
              },
              padding: EdgeInsets.only(top: 15, bottom: 15),
            ),
            const SizedBox(width: 10),
            BetterButton(
              "LB",
              color: Colors.transparent,
              borderColor: Colors.white.withOpacity(
                  userProfileModel.weight.unit == WeightUnit.lb ? 1 : .5),
              style: TextStyle(
                color: Colors.white.withOpacity(
                    userProfileModel.weight.unit == WeightUnit.lb ? 1 : .5),
              ),
              onPressed: () {
                userProfileModel.weight = convertWeight(
                  userProfileModel.weight,
                  WeightUnit.lb,
                );
              },
              padding: EdgeInsets.only(top: 15, bottom: 15),
            )
          ],
        ),
      ],
    );
  }
}
