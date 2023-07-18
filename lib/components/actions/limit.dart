import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LimitationForm extends StatefulWidget {
  const LimitationForm({super.key});

  @override
  LimitationFormState createState() => LimitationFormState();
}

class LimitationFormState extends State<LimitationForm> {
  LimitType limitType = LimitType.alcoholLimit;
  TimeOfDay time = const TimeOfDay(hour: 8, minute: 0);
  double alcoholLimit = 0.1;

  LimitationFormState() {
    LimitModel limitModel = Get.find<LimitModel>();
    if (limitModel.limitation != null) {
      limitType = limitModel.limitation!.type;
      time = limitModel.limitation!.timeOfDay;
      alcoholLimit = limitModel.limitation!.value;
    }
  }

  Widget buildLimitationType({required LimitType type, required String label}) {
    bool isActive = limitType == type;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        child: BetterTextButton(
          label,
          color: Colors.transparent,
          style: TextStyle(color: Colors.white.withOpacity(isActive ? 1 : .5)),
          borderColor: Colors.white.withOpacity(isActive ? 1 : .5),
          onPressed: () async {
            setState(() {
              limitType = type;
            });
          },
        ),
      ),
    );
  }

  List<Widget> buildLimitationForm(BuildContext context) {
    LimitModel limitModel = Get.find<LimitModel>();
    return [
      Text(
        "What's your limit?",
        style: TextStyle(
          color: Colors.white.withOpacity(.75),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildLimitationType(
            type: LimitType.alcoholLimit,
            label: "Alcohol Level",
          ),
          const SizedBox(width: 10),
          buildLimitationType(
            type: LimitType.timeToSober,
            label: "Time Until Sober",
          )
        ],
      ),
      if (limitType == LimitType.alcoholLimit) ...[
        const SizedBox(height: 10),
        Text(
          "Maximum alcohol level (${alcoholLimit.toStringAsFixed(2)} %)",
          style: TextStyle(
            color: Colors.white.withOpacity(.75),
          ),
        ),
        const SizedBox(height: 5),
        Slider(
          value: alcoholLimit,
          onChanged: (value) {
            setState(() {
              alcoholLimit = value;
            });
          },
          min: 0,
          max: 0.4,
          divisions: 40,
          label: "${alcoholLimit.toStringAsFixed(2)} (%)",
        ),
      ],
      if (limitType == LimitType.timeToSober) ...[
        const SizedBox(height: 10),
        Text(
          "Time until sober",
          style: TextStyle(
            color: Colors.white.withOpacity(.75),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: BetterTextButton(
                time.format(context),
                color: Colors.white.withOpacity(.1),
                style: TextStyle(color: Colors.white.withOpacity(1)),
                onPressed: () async {
                  TimeOfDay? input = await showTimePicker(
                    context: context,
                    helpText: "When do you want to be sober?",
                    initialEntryMode: TimePickerEntryMode.inputOnly,
                    initialTime: time,
                  );
                  if (input != null) {
                    setState(() {
                      time = input;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: BetterTextButton(
              "SET LIMIT",
              onPressed: () {
                limitModel.limitation = Limitation(
                  type: limitType,
                  timeOfDay: time,
                  value: double.parse(alcoholLimit.toStringAsFixed(2))!,
                );
                Navigator.of(context).pop();
              },
            ),
          ),
          if (limitModel.limitation != null) ...[
            const SizedBox(width: 10),
            Expanded(
              child: BetterTextButton(
                "RESET LIMIT",
                color: Colors.redAccent.withOpacity(.1),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  limitModel.reset();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildLimitationForm(context),
      ),
    );
  }
}
