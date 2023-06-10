import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  final String activeRoute;
  final Function(String) onNavigate;

  const Navigation(
      {super.key, required this.onNavigate, required this.activeRoute});

  Widget buildNavItem2(BuildContext context,
      {required String path, required IconData icon}) {
    bool active = activeRoute == path;
    return IconButton(
      icon: Icon(icon),
      color: Colors.black.withOpacity(active ? 1 : .5),
      padding: EdgeInsets.zero,
      splashRadius: 1,
      onPressed: () {
        onNavigate(path);
      },
    );
  }

  Widget buildNavItem(BuildContext context,
      {required String path, required IconData icon}) {
    bool active = activeRoute == path;
    return Expanded(
      child: BetterButton(
        "",
        onPressed: () {
          onNavigate(path);
        },
        overlayColor: Colors.black.withOpacity(.1),
        color: Colors.black.withOpacity(active ? .1 : 0),
        child: Icon(
          icon,
          color: active ? Colors.black : Colors.black.withOpacity(.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Container(
        // height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildNavItem(
                context,
                path: "/",
                icon: Icons.home_rounded,
              ),
              // const SizedBox(width: 5),
              // buildNavItem(
              //   context,
              //   path: "/history",
              //   icon: Icons.local_bar_rounded,
              // ),
              const SizedBox(width: 5),
              buildNavItem(
                context,
                path: "/add_drink",
                icon: Icons.add_rounded,
              ),
              // const SizedBox(width: 5),
              // buildNavItem(
              //   context,
              //   path: "/insights",
              //   icon: Icons.insights,
              // ),
              const SizedBox(width: 5),
              buildNavItem(
                context,
                path: "/settings",
                icon: Icons.tune_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
