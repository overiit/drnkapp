import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/components/drink_actions.dart';
import 'package:drnk/components/drink_summary.dart';
import 'package:drnk/components/header.dart';
import 'package:drnk/store/preferences.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  final Function(String) onNavigate;
  final List<Drink> drinks;

  const Home({super.key, required this.onNavigate, required this.drinks});

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
          drinks: widget.drinks,
        ),
        DrinkActions(
          onNavigate: widget.onNavigate,
        ),
        DrinkSummary(
          drinks: widget.drinks,
          onNavigate: widget.onNavigate,
        )
      ],
    );
  }
}
