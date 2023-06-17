import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopNav extends StatelessWidget {
  const TopNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed("/");
            },
            child: const Text(
              "DRNK",
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
            ),
          ),
          const Spacer(),
          // IconButton(
          //   onPressed: () {
          //     Get.toNamed("/add_drink");
          //   },
          //   icon: const Icon(Icons.add),
          //   splashRadius: 20,
          // ),
          IconButton(
            onPressed: () {
              String? activeRoute = ModalRoute.of(context)?.settings.name;
              bool active = activeRoute == "/settings";
              if (active) {
                Get.back();
              } else {
                Get.toNamed("/settings");
              }
            },
            icon: const Icon(
              Icons.tune_rounded,
            ),
            splashRadius: 20,
          )
        ],
      ),
    );
  }
}
