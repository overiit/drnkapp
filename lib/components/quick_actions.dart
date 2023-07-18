import 'package:drnk/components/actions/event.dart';
import 'package:drnk/components/actions/limit.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  QuickActionState createState() => QuickActionState();
}

class QuickActionState extends State<QuickActions> {
  LimitType limitType = LimitType.alcoholLimit;

  Widget quickAction({required Function() onTap, required Widget child}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.1),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget buildLimitation(BuildContext context) {
    final LimitModel limitModel = Get.find<LimitModel>();
    return quickAction(
      onTap: () {
        openWidgetPopup(
          context,
          const LimitationForm(),
        );
      },
      child: Obx(
        () {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (limitModel.limitation == null) ...[
                Text(
                  "Set a",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications),
                    SizedBox(width: 5),
                    Text(
                      "Limit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
              ] else if (limitModel.limitation!.type ==
                  LimitType.timeToSober) ...[
                Text(
                  "Sober by",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.notifications),
                    const SizedBox(width: 5),
                    Text(
                      limitModel.limitation!.timeOfDay.format(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
              ] else if (limitModel.limitation!.type ==
                  LimitType.alcoholLimit) ...[
                Text(
                  "Alcohol Limit",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.notifications),
                    const SizedBox(width: 5),
                    Text(
                      "${limitModel.limitation!.value} %",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
              ]
            ],
          );
        },
      ),
    );
  }

  Widget currentEvent() {
    return quickAction(
      onTap: () {},
      child: Column(
        children: [
          Text(
            "Manage your",
            style: TextStyle(
              color: Colors.white.withOpacity(.5),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month),
              SizedBox(width: 5),
              Text(
                "Events",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildLimitation(context),
            const SizedBox(width: 15),
            currentEvent(),
          ],
        ),
      ),
    );
  }
}
