import 'package:drnk/components/drink_actions.dart';
import 'package:drnk/components/drink_summary.dart';
import 'package:drnk/components/header.dart';
import 'package:drnk/components/quick_actions.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Header(),
        DrinkActions(),
        DrinkSummary(),
        const QuickActions(),
      ],
    );
  }
}
