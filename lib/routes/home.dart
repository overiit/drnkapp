import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/components/drink_actions.dart';
import 'package:drnk/components/drink_summary.dart';
import 'package:drnk/components/header.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final PreferenceModel preferences = Get.find<PreferenceModel>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Header(
          drinks: [],
        ),
        DrinkActions(),
        DrinkSummary()
      ],
    );
  }
}
