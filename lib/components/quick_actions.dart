import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

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

  Widget limitation() {
    final LimitModel limitModel = Get.find<LimitModel>();
    return quickAction(
      onTap: () {},
      child: Obx(
        () {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (limitModel.limitation.value == null) ...[
                Text(
                  "Set up a",
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
              ] else if (limitModel.limitation.value!.type ==
                  LimitType.timeToSober) ...[
                Text(
                  "Limitation",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  limitModel.limitation.value!.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  limitModel.limitation.value!.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ] else if (limitModel.limitation.value!.type ==
                  LimitType.alcoholLimit) ...[
                Text(
                  "BAC",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  limitModel.limitation.value!.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }

  Widget currentEvent() {
    final EventsModel eventsModel = Get.find<EventsModel>();
    return quickAction(
      onTap: () {},
      child: Obx(
        () {
          // an event is active if it has a start time but no end time
          Event? activeEvent = eventsModel.events
              .firstWhereOrNull((element) => element.timestampEnd == null);
          return Column(
            children: [
              if (activeEvent == null) ...[
                Text(
                  "Start an",
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
                      "Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
              ],
            ],
          );
        },
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
            limitation(),
            const SizedBox(width: 15),
            currentEvent(),
          ],
        ),
      ),
    );
  }
}
