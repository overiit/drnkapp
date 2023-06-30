import 'package:drnk/components/buttons/OutlinedTextField.dart';
import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:drnk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDrink extends StatefulWidget {
  @override
  AddDrinkState createState() => AddDrinkState();
}

class AddDrinkState extends State<AddDrink> {
  DrinkType? drinkType;
  Liquid liquid = Liquid(unit: LiquidUnit.ml, amount: 0);
  TextEditingController amountController = TextEditingController();
  double percentage = 0;
  TextEditingController percentageController = TextEditingController();
  double timeago = 0; // minutes
  TextEditingController timeagoController = TextEditingController();

  bool saving = false;

  @override
  void initState() {
    super.initState();
    amountController.addListener(() {
      double? parsed = double.tryParse(amountController.text);
      liquid = Liquid(unit: liquid.unit, amount: parsed ?? 0);
    });
    percentageController.addListener(() {
      percentage = double.tryParse(percentageController.text) ?? 0;
    });
    timeagoController.addListener(() {
      double? parsed = double.tryParse(timeagoController.text);
      if (parsed == null) {
        timeago = 0;
      } else {
        if (parsed.isNaN) {
          timeago = 0;
        } else {
          timeago = parsed * 60;
        }
      }
    });
  }

  createDrink() {
    if (drinkType == null) {
      return;
    }
    setState(() {
      saving = true;
    });
    DrinksModel drinksModel = Get.find<DrinksModel>();
    // timestamp is int
    drinksModel.addDrink(
      Drink(
        type: drinkType!,
        liquid: liquid,
        percentage: percentage,
        timestamp: DateTime.now()
            .subtract(Duration(minutes: timeago.toInt()))
            .millisecondsSinceEpoch,
      ),
    );
    Get.back();
  }

  @override
  void dispose() {
    amountController.dispose();
    percentageController.dispose();
    timeagoController.dispose();
    super.dispose();
  }

  Widget buildDrinkType(DrinkType type) {
    bool isActive = drinkType == type;
    return Container(
      padding: EdgeInsets.only(bottom: isActive ? 5 : 15),
      child: GestureDetector(
        onTap: () {
          setState(() {
            drinkType = isActive ? null : type;
            if (!isActive) {
              Drink? defaultDrink = defaultDrinkValues(type);
              if (defaultDrink != null) {
                liquid = convertLiquid(defaultDrink.liquid, liquid.unit);
                amountController.text = liquid.amount.toStringAsFixed(2);
                percentageController.text =
                    defaultDrink.percentage.toStringAsFixed(2);
              }
              timeago = 0;
              timeagoController.text = '';
            } else {
              amountController.text = '';
              percentageController.text = '';
              timeagoController.text = '';
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          width: double.infinity,
          height: 92,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Text(
                  type.name.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 42,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.left,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image(
                  image: AssetImage('lib/assets/add/${type.name}.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLiquidUnit(LiquidUnit unit, String label) {
    bool isActive = liquid.unit == unit;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: BetterTextButton(
        unit.name.toUpperCase(),
        color: Colors.transparent,
        style: TextStyle(color: Colors.white.withOpacity(isActive ? 1 : .5)),
        borderColor: Colors.white.withOpacity(isActive ? 1 : .5),
        onPressed: () {
          setState(() {
            liquid = convertLiquid(liquid, unit);
            amountController.text = liquid.amount.toStringAsFixed(2);
          });
        },
      ),
    );
  }

  Widget buildAmountInput() {
    return Expanded(
      child: BetterTextField(
        color: Colors.white,
        style: const TextStyle(color: Colors.white),
        hintText: "Drink Amount",
        isNumber: true,
        controller: amountController,
        initialValue: doubleToString(liquid.amount),
        onChanged: (amount) {
          setState(() {
            liquid.amount = double.tryParse(amount) ?? 0;
          });
        },
      ),
    );
  }

  Widget buildPercentageInput() {
    return Expanded(
      child: BetterTextField(
        color: Colors.white,
        style: const TextStyle(color: Colors.white),
        hintText: "Percentage",
        isNumber: true,
        controller: percentageController,
        initialValue: doubleToString(percentage),
        onChanged: (percentage) {
          setState(() {
            this.percentage = double.tryParse(percentage) ?? 0;
          });
        },
      ),
    );
  }

  Widget buildTimeAgo() {
    return Expanded(
      child: BetterTextField(
        color: Colors.white,
        style: const TextStyle(color: Colors.white),
        hintText: "Hours ago",
        isNumber: true,
        controller: timeagoController,
        initialValue: doubleToString(timeago.toDouble() / 60),
        onChanged: (timeago) {
          setState(() {
            this.timeago = (double.tryParse(timeago) ?? 0) * 60;
          });
        },
      ),
    );
  }

  Widget buildTimeAgoUnit(int time, String label) {
    bool isActive = timeago == time;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: BetterTextButton(
        label,
        color: Colors.transparent,
        style: TextStyle(color: Colors.white.withOpacity(isActive ? 1 : .5)),
        borderColor: Colors.white.withOpacity(isActive ? 1 : .5),
        onPressed: () {
          setState(() {
            timeagoController.text = doubleToString(time.toDouble() / 60);
          });
        },
      ),
    );
  }

  Widget buildTimeAgoQuickButtons() {
    return Row(
      children: [
        buildTimeAgoUnit(0, "Now"),
        buildTimeAgoUnit(30, "30m"),
        buildTimeAgoUnit(60, "1h"),
      ],
    );
  }

  Widget buildFormTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withOpacity(.75),
        fontWeight: FontWeight.w700,
        letterSpacing: -.5,
      ),
    );
  }

  Widget buildEstimate() {
    final UserProfileModel profileModel = Get.find();
    Drink currentDrink = Drink(
      type: drinkType ?? DrinkType.beer,
      liquid: liquid,
      percentage: percentage,
      timestamp: DateTime.now()
          .subtract(Duration(minutes: timeago.toInt()))
          .millisecondsSinceEpoch,
      calc: DrinkCalc(bacDrink: 0, bacStart: 0),
    );
    double timeProcessed =
        bacDecrease(Duration(minutes: timeago.toInt()).inMilliseconds);
    double bac = calculateDrinkBac(
          profileModel,
          currentDrink,
        ) -
        timeProcessed;
    if (bac < 0) bac = 0;
    String currentBac = doubleToString(double.parse((bac).toStringAsFixed(3)));
    int timeToSoberNumber = calculateTimeUntilSoberByBac(bac);
    String timeToSober = timeSpanDuration(timeToSoberNumber);

    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: BetterTextButton(
              "Alcohol Level +$currentBac%",
              color: Colors.white.withOpacity(.1),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: BetterTextButton(
              "Time To Sober: +$timeToSober",
              color: Colors.white.withOpacity(.1),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 40,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: BetterTextButton(
        !saving ? "ADD DRINK" : "ADDING...",
        color: Colors.white.withOpacity(!saving ? 1 : .2),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
        ),
        onPressed: !saving ? createDrink : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (drinkType != null) {
      children.addAll([
        buildFormTitle("How much did you drink?"),
        Row(
          children: [
            buildAmountInput(),
            ...LiquidUnit.values.map((e) {
              return buildLiquidUnit(e, e.name);
            }).toList()
          ],
        ),
        const SizedBox(height: 10),
      ]);
      if (liquid.amount > 0) {
        children.addAll([
          buildFormTitle("What was the percentage?"),
          const SizedBox(height: 5),
          Row(
            children: [
              buildPercentageInput(),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Icon(
                  Icons.percent,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ]);
        if (percentage > 0) {
          children.addAll([
            buildFormTitle("When did you drink this?"),
            Row(
              children: [
                buildTimeAgoQuickButtons(),
                buildTimeAgo(),
              ],
            ),
          ]);
          children.add(buildEstimate());
          children.add(buildSubmitButton());
        }
      }
    }

    List<Widget> drinkTypes = [];
    if (drinkType != null) {
      drinkTypes.add(buildDrinkType(drinkType!));
    } else {
      drinkTypes.addAll(DrinkType.values.map((e) {
        return buildDrinkType(e);
      }).toList());
    }

    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...drinkTypes,
          ...children,
        ],
      ),
    );
  }
}
