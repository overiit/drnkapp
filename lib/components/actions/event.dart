import 'package:drnk/components/buttons/OutlinedTextField.dart';
import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EndEventModal extends StatelessWidget {
  final Event event;
  const EndEventModal({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    DrinksModel drinksModel = Get.find();
    int drinkCount = drinksModel.drinks.where((drink) {
      return event.timestampStart <= drink.timestamp &&
          (event.timestampEnd == null ||
              drink.timestamp <= event.timestampEnd!);
    }).length;
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: [
          const Text("Are you sure you want to end this event?"),
          const SizedBox(height: 10),
          if (drinkCount == 0) ...[
            // short version of You have not added any drinks to this event, so it will be deleted.
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(.1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: const Text(
                "No drinks have been added to this event, so it will be deleted.",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(
                child: BetterTextButton(
                  "END EVENT",
                  onPressed: () {
                    EventsModel eventsModel = Get.find();
                    eventsModel.endEvent(event);
                    Navigator.of(context).pop();
                  },
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CreateEventModal extends StatefulWidget {
  const CreateEventModal({Key? key}) : super(key: key);

  @override
  CreateEventModalState createState() => CreateEventModalState();
}

class CreateEventModalState extends State<CreateEventModal> {
  String eventName = "Drnk Event";
  bool advancedOptions = false;
  DateTime? eventStart;
  DateTime? eventEnd;

  List<Widget> buildEventCreationForm(BuildContext context) {
    return [
      const SizedBox(height: 10),
      Text(
        "What is the name of your event? (optional)",
        style: TextStyle(
          color: Colors.white.withOpacity(.75),
        ),
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          Expanded(
            child: BetterTextField(
              hintText: "New Event",
              color: Colors.white.withOpacity(.5),
              style: TextStyle(color: Colors.white.withOpacity(1)),
              onChanged: (value) {
                setState(() {
                  eventName = value;
                });
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: () {
          setState(() {
            advancedOptions = !advancedOptions;
          });
        },
        child: Container(
          padding: const EdgeInsets.only(left: 0, right: 15),
          child: Row(
            children: [
              Text(
                "Advanced Options",
                style: TextStyle(color: Colors.white.withOpacity(.75)),
              ),
              Icon(
                advancedOptions
                    ? Icons.arrow_drop_up_outlined
                    : Icons.arrow_drop_down_outlined,
                color: Colors.white.withOpacity(.75),
              ),
            ],
          ),
        ),
      ),
      if (advancedOptions) ...[
        const SizedBox(height: 10),
        // datetime picker
        Text(
          "When is your event?",
          style: TextStyle(
            color: Colors.white.withOpacity(.75),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: BetterTextField(
                hintText: "New Event",
                color: Colors.white.withOpacity(.5),
                style: TextStyle(color: Colors.white.withOpacity(1)),
                onChanged: (value) {
                  setState(() {
                    eventName = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: BetterTextButton(
              "START EVENT",
              onPressed: () {
                EventsModel eventsModel = Get.find();
                eventsModel.createEvent(name: eventName);
                Navigator.of(context).pop();
              },
              color: Colors.white,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildEventCreationForm(context),
      ),
    );
  }
}
