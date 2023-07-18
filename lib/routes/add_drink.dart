import 'package:drnk/components/buttons/OutlinedTextField.dart';
import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/components/drink_listview.dart';
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

  bool customLiquid = false;
  Liquid liquid = Liquid(unit: LiquidUnit.ml, amount: 0);
  bool isEditedLiquid = false;

  bool customPercentage = false;
  TextEditingController amountController = TextEditingController();
  double percentage = 0;

  bool customTimeAgo = false;
  TextEditingController percentageController = TextEditingController();
  double timeago = 0; // minutes

  TextEditingController timeagoController = TextEditingController();

  bool saving = false;
  bool ignoreLimit = false;

  bool isDefault = false;

  @override
  void initState() {
    super.initState();
    amountController.addListener(() {
      isDefault = false;
      double? parsed = double.tryParse(amountController.text);
      liquid = Liquid(unit: liquid.unit, amount: parsed ?? 0);
    });
    percentageController.addListener(() {
      isDefault = false;
      percentage = double.tryParse(percentageController.text) ?? 0;
    });
    timeagoController.addListener(() {
      isDefault = false;
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
        name: drinkType!.name.capitalizeFirst ?? "Drink",
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
                liquid = defaultDrink.liquid;
                amountController.text = doubleToString(liquid.amount);
                percentageController.text =
                    doubleToString(defaultDrink.percentage);
              }
              timeago = 0;
              timeagoController.text = '';

              // allow it to default convert
              isDefault = true;
            } else {
              amountController.text = '';
              percentageController.text = '';
              timeagoController.text = '';

              isEditedLiquid = false;
              customLiquid = false;
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

  Widget buildDefaultLiquid(Liquid liquid) {
    bool isActive = !customLiquid &&
        (this.liquid.amount == liquid.amount &&
            this.liquid.unit == liquid.unit);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: BetterTextButton(
          "${doubleToString(liquid.amount)} ${liquid.unit.name}",
          color: Colors.transparent,
          style: TextStyle(color: Colors.white.withOpacity(isActive ? 1 : .5)),
          borderColor: Colors.white.withOpacity(isActive ? 1 : .5),
          onPressed: () {
            setState(() {
              this.liquid.unit = liquid.unit;
              amountController.text = liquid.amount.toStringAsFixed(2);
              customLiquid = false;
              isEditedLiquid = false;
            });
          },
        ),
      ),
    );
  }

  Widget buildCustomLiquid() {
    return Expanded(
      child: BetterTextButton(
        "Custom",
        color: Colors.transparent,
        style:
            TextStyle(color: Colors.white.withOpacity(customLiquid ? 1 : .5)),
        borderColor: Colors.white.withOpacity(customLiquid ? 1 : .5),
        onPressed: () {
          setState(() {
            customLiquid = true;
          });
        },
      ),
    );
  }

  Widget buildCustomPercentage() {
    return Expanded(
      child: BetterTextButton(
        "Custom",
        color: Colors.transparent,
        style: TextStyle(
            color: Colors.white.withOpacity(customPercentage ? 1 : .5)),
        borderColor: Colors.white.withOpacity(customPercentage ? 1 : .5),
        onPressed: () {
          setState(() {
            customPercentage = true;
          });
        },
      ),
    );
  }

  Widget buildLiquidUnit(LiquidUnit unit, String label) {
    bool isActive = liquid.unit == unit;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: BetterTextButton(
        unit.name.toUpperCase(),
        color: Colors.transparent,
        style: TextStyle(color: Colors.white.withOpacity(isActive ? 1 : .5)),
        borderColor: Colors.white.withOpacity(isActive ? 1 : .5),
        onPressed: () {
          setState(() {
            if (isEditedLiquid) {
              liquid = convertLiquid(liquid, unit);
            } else {
              liquid = defaultLiquidUnitValue(drinkType!, unit);
            }
            amountController.text =
                doubleToString(liquid.amount, fractionDigits: 2);
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
          isEditedLiquid = true;
          setState(() {
            liquid.amount = double.tryParse(amount) ?? 0;
          });
        },
      ),
    );
  }

  Widget buildDefaultPercentage(double percentage) {
    bool isActive = !customPercentage && this.percentage == percentage;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: BetterTextButton(
          "${doubleToString(percentage)} %",
          color: Colors.transparent,
          style: TextStyle(color: Colors.white.withOpacity(isActive ? 1 : .5)),
          borderColor: Colors.white.withOpacity(isActive ? 1 : .5),
          onPressed: () {
            setState(() {
              this.percentage = percentage;
              percentageController.text = doubleToString(percentage);
              customPercentage = false;
            });
          },
        ),
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
        initialValue: doubleToString(
          percentage,
          fractionDigits: 3,
        ),
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
    bool isActive = timeago == time && !customTimeAgo;
    return Expanded(
      child: BetterTextButton(
        label,
        color: Colors.transparent,
        style: TextStyle(color: Colors.white.withOpacity(isActive ? 1 : .5)),
        borderColor: Colors.white.withOpacity(isActive ? 1 : .5),
        onPressed: () {
          setState(() {
            timeagoController.text = doubleToString(time.toDouble() / 60);
            customTimeAgo = false;
          });
        },
      ),
    );
  }

  Widget buildCustomTimeAgo() {
    return Expanded(
      child: BetterTextButton(
        "Custom",
        color: Colors.transparent,
        style:
            TextStyle(color: Colors.white.withOpacity(customTimeAgo ? 1 : .5)),
        borderColor: Colors.white.withOpacity(customTimeAgo ? 1 : .5),
        onPressed: () {
          setState(() {
            customTimeAgo = true;
          });
        },
      ),
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

  Widget? buildLimitAlert({
    required double drinkBac,
  }) {
    DrinksModel drinksModel = Get.find();
    LimitModel limitModel = Get.find();
    if (limitModel.limitation == null) return null;
    String? limitMessage;
    double currentBac = 0;
    if (drinksModel.drinks.isNotEmpty) {
      currentBac = calculateBac(drinksModel.drinks[0]);
    }
    if (limitModel.limitation!.type == LimitType.alcoholLimit) {
      // calculate if alcohol limit applies
      if (limitModel.limitation!.value < currentBac + drinkBac) {
        limitMessage =
            "You will exceed your alcohol limit of ${limitModel.limitation!.value.toStringAsFixed(2)}% with this drink.";
      }
    } else if (limitModel.limitation!.type == LimitType.timeToSober) {
      final timeUntilSober =
          ((currentBac + drinkBac) / 0.015) * 60.0 * 60.0 * 1000.0;

      TimeOfDay time = limitModel.limitation!.timeOfDay;
      DateTime now = DateTime.now();
      DateTime expectedSober;
      if (now.hour > time.hour ||
          (now.hour == time.hour && now.minute > time.minute)) {
        expectedSober =
            DateTime(now.year, now.month, now.day + 1, time.hour, time.minute);
      } else {
        expectedSober =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
      }

      if (expectedSober.millisecondsSinceEpoch <
          now.millisecondsSinceEpoch + timeUntilSober) {
        limitMessage = "You will not be sober by ${time.format(context)}";
      }
    }
    if (limitMessage == null) return null;
    return Row(
      children: [
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            limitMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.redAccent),
          ),
        ))
      ],
    );
  }

  Widget buildEstimate(
      {required String currentBac, required String timeToSober}) {
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
            width: 5,
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
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: BetterTextButton(
            !saving ? "ADD DRINK" : "ADDING...",
            color: Colors.white.withOpacity(!saving ? 1 : .2),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
            onPressed: !saving ? createDrink : null,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: BetterTextButton(
            "SAVE",
            color: Colors.white.withOpacity(.1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            icon: Icons.favorite_outline,
          ),
        ),
      ],
    );
  }

  Widget buildIgnoreLimitButton() {
    // this is a check box
    return Row(
      children: [
        Switch(
          value: ignoreLimit,
          onChanged: (value) {
            setState(() {
              ignoreLimit = value;
            });
          },
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              ignoreLimit = !ignoreLimit;
            });
          },
          child: Text(
            "Ignore Limit",
            style: TextStyle(
              color: Colors.white.withOpacity(.75),
              fontWeight: FontWeight.w700,
              letterSpacing: -.5,
            ),
          ),
        )
      ],
    );
  }

  // recentDrinks
  int itemsPerPage = 5;
  int page = 1;

  List<Widget> buildRecentDrinks() {
    DrinksModel drinksModel = Get.find();
    if (drinksModel.drinks.isEmpty) return [Container()];
    return [
      Obx(() {
        int pageStart = ((page - 1) * itemsPerPage);
        int pageEnd = ((page - 1) * itemsPerPage) + itemsPerPage;
        if (pageEnd > drinksModel.drinks.length) {
          pageEnd = drinksModel.drinks.length;
        }
        return DrinkListView(
          key: ValueKey(page),
          drinks: drinksModel.drinks.getRange(pageStart, pageEnd).toList(),
          action: (drink) => BetterTextButton(
            "COPY",
            color: Colors.white.withOpacity(.1),
            style: const TextStyle(color: Colors.white),
            onPressed: () {
              setState(() {
                drinkType = drink.type;
                liquid = drink.liquid;
                percentage = drink.percentage;

                customLiquid = true;
                isEditedLiquid = true;

                customPercentage = true;
              });
            },
          ),
        );
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    final UserProfileModel profileModel = Get.find();
    Drink currentDrink = Drink(
      name: drinkType?.name.capitalizeFirst ?? "Drink",
      type: drinkType ?? DrinkType.other,
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
    String currentBac = doubleToString(bac, fractionDigits: 3);
    int timeToSoberNumber = calculateTimeUntilSoberByBac(bac);
    String timeToSober = timeSpanDuration(timeToSoberNumber);

    if (drinkType != null) {
      List<Liquid> defaultLiquids = defaultDrinkLiquids(drinkType!);
      List<double> defaultPercentages = defaultDrinkPercentages(drinkType!);
      Widget? limit = buildLimitAlert(drinkBac: bac);
      children = [
        buildFormTitle("How much did you drink?"),
        if (defaultLiquids.isNotEmpty)
          Row(
            children: [
              ...defaultLiquids.map((e) {
                return buildDefaultLiquid(e);
              }).toList(),
              buildCustomLiquid(),
            ],
          ),
        if ((customLiquid && defaultLiquids.isNotEmpty) ||
            defaultLiquids.isEmpty)
          Row(
            children: [
              buildAmountInput(),
              ...LiquidUnit.values.map((e) {
                return buildLiquidUnit(e, e.name);
              }).toList()
            ],
          ),
        const SizedBox(height: 10),
        buildFormTitle("What was the percentage?"),
        const SizedBox(height: 5),
        if (defaultPercentages.isNotEmpty)
          Row(
            children: [
              ...defaultPercentages.map((e) {
                return buildDefaultPercentage(e);
              }).toList(),
              buildCustomPercentage(),
            ],
          ),
        if ((customPercentage && defaultPercentages.isNotEmpty) ||
            defaultPercentages.isEmpty)
          Row(
            children: [
              buildPercentageInput(),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: Icon(
                    Icons.percent,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),
        buildFormTitle("When did you drink this?"),
        Row(
          children: [
            buildTimeAgoUnit(0, "Now"),
            const SizedBox(width: 5),
            buildTimeAgoUnit(30, "30m"),
            const SizedBox(width: 5),
            buildTimeAgoUnit(60, "1h"),
            const SizedBox(width: 5),
            buildCustomTimeAgo(),
          ],
        ),
        if (customTimeAgo)
          Row(
            children: [
              buildTimeAgo(),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: Icon(
                    Icons.timer_outlined,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),
        buildEstimate(currentBac: currentBac, timeToSober: timeToSober),
        if (limit != null) ...[
          limit,
          buildIgnoreLimitButton(),
        ],
      ];
      if (liquid.amount > 0 && percentage > 0 && timeago >= 0) {
        if (limit == null || ignoreLimit) {
          children.add(buildSubmitButton());
        }
      }
    } else {
      children = [
        buildFormTitle("Recent Drinks"),
        const SizedBox(height: 10),
        ...buildRecentDrinks(),
      ];
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
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
