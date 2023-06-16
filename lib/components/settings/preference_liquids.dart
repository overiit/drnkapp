import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferenceLiquids extends StatelessWidget {
  const PreferenceLiquids({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const Text('Milliliters'),
          onTap: () {
            PreferenceModel preferenceModel = Get.find();
            preferenceModel.liquidUnit = LiquidUnit.ml;
            preferenceModel.update();
            Get.back();
          },
        ),
        ListTile(
          title: const Text('Ounces'),
          onTap: () {
            PreferenceModel preferenceModel = Get.find();
            preferenceModel.liquidUnit = LiquidUnit.oz;
            preferenceModel.update();
            Get.back();
          },
        ),
        ListTile(
          title: const Text('Pints'),
          onTap: () {
            PreferenceModel preferenceModel = Get.find();
            preferenceModel.liquidUnit = LiquidUnit.pt;
            preferenceModel.update();
            Get.back();
          },
        )
      ],
    );
  }
}
