import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/store/stores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetApp extends StatelessWidget {
  const ResetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: [
          const Text("Reset App"),
          const SizedBox(height: 10),
          const Text(
              "This will reset the app to its default state. This will delete all your data."),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BetterButton(
                  "Reset",
                  onPressed: () {
                    DataLoader dataLoader = Get.find<DataLoader>();
                    dataLoader.reset();
                    Navigator.of(context).pop(true);
                  },
                  color: Colors.redAccent.withOpacity(.75),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BetterButton(
                  "Cancel",
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.white.withOpacity(.1),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
