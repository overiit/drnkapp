import 'dart:async';

import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:drnk/utils/utils.dart';
import 'package:flutter/material.dart';

class DrinkListView extends StatefulWidget {
  final List<Drink> drinks;

  const DrinkListView({super.key, required this.drinks});

  @override
  DrinkListViewState createState() => DrinkListViewState();
}

class DrinkListViewState extends State<DrinkListView> {
  Timer? updateTimer;

  bool isEditing = false;
  List<Drink> drinks = [];

  @override
  void initState() {
    super.initState();

    updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      update();
    });
  }

  @override
  void dispose() {
    super.dispose();

    updateTimer?.cancel();
  }

  void update() {
    setState(() {});
  }

  Widget buildDrink(Drink drink, {bool isLast = false}) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isEditing = true;
        });
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: isLast ? 5 : 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 34,
              width: 55,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                drink.icon,
                color: Colors.white,
                size: 25,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalize(drink.type.name),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${drink.percentage}% - ${drink.liquid.amount}${drink.liquid.unit.name} - ${timeAgo(time: drink.timestamp, short: true)}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(.6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                "+ ${(drink.calc?.bacDrink ?? 0).toStringAsFixed(3)}%",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.drinks
          .map((drink) => buildDrink(drink,
              isLast: widget.drinks.indexOf(drink) == widget.drinks.length - 1))
          .toList(),
    );
  }
}
