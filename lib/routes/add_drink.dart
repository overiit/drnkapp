import 'package:drnk/components/buttons/OutlinedTextField.dart';
import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';

class AddDrink extends StatefulWidget {
  final Function(Drink) createDrink;
  const AddDrink({super.key, required this.createDrink});

  @override
  _AddDrinkState createState() => _AddDrinkState();
}

class _AddDrinkState extends State<AddDrink> {
  DrinkType? drinkType;
  Liquid liquid = Liquid(unit: LiquidUnit.ml, amount: 0);
  TextEditingController amountController = TextEditingController();
  double percentage = 0;
  TextEditingController percentageController = TextEditingController();
  int timeago = 0;
  TextEditingController timeagoController = TextEditingController();

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
      int? parsed = int.tryParse(timeagoController.text);
      if (parsed == null) {
        timeago = 0;
      } else {
        if (parsed.isNaN) {
          timeago = 0;
        } else {
          timeago = parsed;
        }
      }
    });
  }

  createDrink() {
    if (drinkType == null) {
      return;
    }
    // timestamp is int
    widget.createDrink(Drink(
      type: drinkType!,
      liquid: liquid,
      percentage: percentage,
      timestamp: DateTime.now()
          .subtract(Duration(minutes: (60 * (timeago ?? 0)).toInt()))
          .millisecondsSinceEpoch,
    ));
    setState(() {
      drinkType = null;
      amountController.clear();
      percentageController.clear();
      timeagoController.clear();
    });
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
      padding: EdgeInsets.only(bottom: 15),
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
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: BetterButton(
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
        initialValue: liquid.amount.toString(),
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
        initialValue: percentage.toString(),
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
        initialValue: timeago.toString(),
        onChanged: (timeago) {
          setState(() {
            this.timeago = int.tryParse(timeago) ?? 0;
          });
        },
      ),
    );
  }

  Widget buildTimeAgoUnit(int time, String label) {
    bool isActive = timeago == time;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: BetterButton(
        label,
        color: Colors.transparent,
        style: TextStyle(color: Colors.white.withOpacity(isActive ? 1 : .5)),
        borderColor: Colors.white.withOpacity(isActive ? 1 : .5),
        onPressed: () {
          setState(() {
            timeago = time;
            timeagoController.text = time.toString();
          });
        },
      ),
    );
  }

  Widget buildTimeAgoQuickButtons() {
    return Row(
      children: [
        buildTimeAgoUnit(0, "Now"),
        buildTimeAgoUnit(1, "1h"),
      ],
    );
  }

  Widget buildFormTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        letterSpacing: -.5,
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
      child: TextButton(
        onPressed: () {
          createDrink();
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Text(
          'ADD DRINK',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              letterSpacing: -.5),
        ),
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

          if (timeago != null) {
            children.add(buildSubmitButton());
          }
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
