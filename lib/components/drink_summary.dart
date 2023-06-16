import 'dart:math';

import 'package:drnk/components/drink_listview.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrinkSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DrinksModel drinksModel = Get.find<DrinksModel>();
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Activity",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Obx(
            () => Stack(
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
                        stops: [0, 1],
                      ),
                      // color: Colors.red
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: BetterButton(
          //         "VIEW ALL",
          //         onPressed: () {
          //           onNavigate("/history");
          //         },
          //         style: TextStyle(
          //           color: Colors.white.withOpacity(.75),
          //           fontWeight: FontWeight.w800,
          //         ),
          //         color: Colors.white.withOpacity(.1),
          //         padding: 0,
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
