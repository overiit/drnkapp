import 'dart:math';

import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/components/drink_listview.dart';
import 'package:drnk/components/section_title.dart';
import 'package:drnk/store/stores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrinkSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DrinksModel drinksModel = Get.find<DrinksModel>();
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "Recent Activity"),
            if (drinksModel.drinks.isNotEmpty) ...[
              Stack(
                children: [
                  DrinkListView(
                    drinks: drinksModel.drinks.sublist(
                      0,
                      min(5, drinksModel.drinks.length),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: -1,
                    right: 1,
                    height: min(3, drinksModel.drinks.length) * 50,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF181818).withOpacity(0),
                            Color(0xFF181818)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, .85],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        children: [
                          Expanded(
                            child: BetterTextButton(
                              "VIEW ALL",
                              onPressed: () {
                                Get.toNamed("/history");
                              },
                              style: TextStyle(
                                color: Colors.white.withOpacity(.75),
                                fontWeight: FontWeight.w800,
                              ),
                              overlayColor: Colors.white.withOpacity(.1),
                              color: Colors.transparent,
                              padding: const EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ] else ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You haven't added any drinks yet.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.5),
                    ),
                  ),
                ],
              )
            ],
          ],
        ),
      );
    });
  }
}
