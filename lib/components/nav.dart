import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  Widget buildNavItem(BuildContext context,
      {required String path, required IconData icon}) {
    String? activeRoute = ModalRoute.of(context)?.settings.name;
    bool active = activeRoute == path;
    return Expanded(
      child: BetterTextButton(
        "",
        onPressed: () {
          Get.toNamed(path);
        },
        overlayColor: Colors.white.withOpacity(.1),
        color: Colors.white.withOpacity(active ? 1 : 0),
        child: Icon(
          icon,
          color: active
              ? Colors.black.withOpacity(1)
              : Colors.white.withOpacity(active ? 1 : .5),
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
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNavItem(
              context,
              path: "/",
              icon: Icons.home_rounded,
            ),
            const SizedBox(width: 5),
            buildNavItem(
              context,
              path: "/history",
              icon: Icons.local_bar,
            ),
            const SizedBox(width: 5),
            buildNavItem(
              context,
              path: "/add_drink",
              icon: Icons.add_rounded,
            ),
            const SizedBox(width: 5),
            buildNavItem(
              context,
              path: "/events",
              icon: Icons.calendar_month_outlined,
            ),
            const SizedBox(width: 5),
            buildNavItem(
              context,
              path: "/settings",
              icon: Icons.tune_outlined,
            ),
            // const SizedBox(width: 5),
            // buildNavItem(
            //   context,
            //   path: "/recipes",
            //   icon: Icons.menu_book_rounded,
            // ),
          ],
        ),
      ),
    );
  }
}
