import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  Widget buildNavItem(BuildContext context,
      {required String path, required IconData icon}) {
    String? activeRoute = ModalRoute.of(context)?.settings.name;
    // bool isHome = path == "/";
    bool active = activeRoute == path;
    // || (isHome && activeRoute == "/") || (!isHome && (activeRoute ?? "/").startsWith(path))
    return Expanded(
      child: BetterButton(
        "",
        onPressed: () {
          Get.toNamed(path);
        },
        overlayColor: Colors.white.withOpacity(.1),
        color: Colors.white.withOpacity(active ? .1 : 0),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(active ? 1 : .5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
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
    );
  }
}
