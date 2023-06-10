import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:flutter/material.dart';

class TopNav extends StatelessWidget {

  final Function(String) onNavigate;

  const TopNav({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "DRNK",
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
          ),
          // ... icons?

          // BetterButton(
          //   "+ DRINK",
          //   onPressed: () {
          //     onNavigate("/add_drink");
          //   },
          //   color: Colors.white,
          //   style: TextStyle(
          //     fontWeight: FontWeight.w900,
          //   ),
          // ),
        ],
      ),
    );
  }
}
