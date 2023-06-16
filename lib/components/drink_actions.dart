import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrinkActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: BetterButton(
              "ADD DRINK",
              onPressed: () {
                Get.toNamed("/add_drink");
              },
              color: Colors.white,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: BetterButton(
              "VIEW DRINKS",
              onPressed: () {
                Get.toNamed("/history");
              },
              color: Colors.white.withOpacity(.1),
              overlayColor: Colors.white.withOpacity(.1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
