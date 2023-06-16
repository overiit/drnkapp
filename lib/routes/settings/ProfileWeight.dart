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
  final UserProfileModel userProfileModel = Get.find<UserProfileModel>();

  Weight weight = Weight(amount: 0, unit: WeightUnit.kg);

  @override
  void initState() {
    super.initState();
    weight = userProfileModel.weight;
  }

  List<Widget> buildForm() {
    return [
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
      Obx(
        () => Row(
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
                  setState(() {
                    if (amount != null) {
                      weight.amount = amount;
                    } else {
                      weight.amount = 0;
                    }
                  });
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
                setState(() {
                  weight.unit = WeightUnit.kg;
                });
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
                setState(() {
                  weight.unit = WeightUnit.lb;
                });
              },
              padding: EdgeInsets.only(top: 15, bottom: 15),
            )
          ],
        ),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: BetterButton(
              "Save",
              color: Colors.white,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              onPressed: () {
                userProfileModel.weight = weight;
                userProfileModel.update();
                Get.toNamed("/settings");
              },
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildForm(),
      ),
    );
  }
}
