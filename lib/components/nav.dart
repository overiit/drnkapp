import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  Widget buildNavItem2(BuildContext context,
      {required String path, required IconData icon}) {
    String? activeRoute = ModalRoute.of(context)?.settings.name;
    bool active = activeRoute == path;
    return IconButton(
      icon: Icon(icon),
      color: Colors.black.withOpacity(active ? 1 : .5),
      padding: EdgeInsets.zero,
      splashRadius: 1,
      onPressed: () {
        Get.toNamed(path);
      },
    );
  }

  Widget buildNavItem(BuildContext context,
      {required String path, required IconData icon}) {
    String? activeRoute = ModalRoute.of(context)?.settings.name;
    bool active = activeRoute == path;
    return Expanded(
      child: BetterButton(
        "",
        onPressed: () {
          Get.toNamed(path);
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
    return Container(
      // height: 50,
      decoration: const BoxDecoration(
          color: Colors.white,
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
