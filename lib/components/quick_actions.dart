import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  LimitType limitType = LimitType.alcoholLimit;

  @override
  QuickActionState createState() => QuickActionState();
}

class QuickActionState extends State<QuickActions> {
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

  Widget buildLimitationType({required LimitType type, required String label}) {
    bool isActive = limitType == type;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        child: BetterTextButton(
          label,
          color: Colors.transparent,
          style: TextStyle(color: Colors.white.withOpacity(isActive ? 1 : .5)),
          borderColor: Colors.white.withOpacity(isActive ? 1 : .5),
          onPressed: () {
            setState(() {
              limitType = type;
            });
          },
        ),
      ),
    );
  }

  List<Widget> buildLimitationForm(BuildContext context) {
    return [
      Text(
        "How would you like to get alerted?",
        style: TextStyle(
          color: Colors.white.withOpacity(.75),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildLimitationType(
            type: LimitType.alcoholLimit,
            label: "Alcohol Level",
          ),
          buildLimitationType(
            type: LimitType.timeToSober,
            label: "Time Until Sober",
          )
        ],
      ),
      if (limitType == LimitType.timeToSober)
        Row(
          children: [
            BetterTextButton(
              "asd",
              onPressed: () {
                showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 0, minute: 0),
                );
              },
            ),
          ],
        )
    ];
  }

  Widget configureLimitation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildLimitationForm(context),
      ),
    );
  }

  Widget buildLimitation(BuildContext context) {
    final LimitModel limitModel = Get.find<LimitModel>();
    return quickAction(
      onTap: () {
        openWidgetPopup(context, configureLimitation(context));
      },
      child: Obx(
        () {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (limitModel.limitation.value == null) ...[
                Text(
                  "Create a",
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

  void openWidgetPopup(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: child,
          ),
        );
      },
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
