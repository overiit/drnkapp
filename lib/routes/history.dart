import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/components/drink_listview.dart';
import 'package:drnk/components/pagination.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String name;
  final String info;
  final String timeAgo;
  final String stats;

  const CustomListItem({
    Key? key,
    required this.color,
    required this.icon,
    required this.name,
    required this.info,
    required this.timeAgo,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' $info',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Text(timeAgo, style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
          Text(
            stats,
            style:
                const TextStyle(fontWeight: FontWeight.w900, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> {
  bool editing = false;

  List<Drink> selectedDrinks = [];

  int itemsPerPage = 10;
  int page = 1;

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

  Widget removeDrinksConfirmation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: [
          Text(
              "Are you sure you want to delete ${selectedDrinks.length} drinks?"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BetterTextButton(
                  "Delete",
                  onPressed: () {
                    DrinksModel drinksModel = Get.find<DrinksModel>();
                    Navigator.of(context).pop(true);
                    drinksModel.removeDrinks(selectedDrinks);
                    editing = false;
                    selectedDrinks = [];
                  },
                  color: Colors.redAccent.withOpacity(.75),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BetterTextButton(
                  "Cancel",
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.white.withOpacity(.1),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DrinksModel drinksModel = Get.find<DrinksModel>();
    return Obx(() {
      int pageStart = ((page - 1) * itemsPerPage);
      int pageEnd = ((page - 1) * itemsPerPage) + itemsPerPage;
      if (pageEnd > drinksModel.drinks.length) {
        pageEnd = drinksModel.drinks.length;
      }
      return Container(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          children: [
            if (drinksModel.drinks.length > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BetterTextButton(
                    editing ? "Done" : "Edit",
                    onPressed: () {
                      setState(() {
                        editing = !editing;
                        if (!editing) {
                          selectedDrinks = [];
                        }
                      });
                    },
                    color: Colors.white.withOpacity(.1),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  if (editing) ...[
                    const SizedBox(width: 10),
                    Text(
                      "${selectedDrinks.length} selected",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: selectedDrinks.length > 0
                          ? () {
                              openWidgetPopup(
                                  context, removeDrinksConfirmation(context));
                            }
                          : null,
                      icon: Icon(Icons.delete,
                          color: selectedDrinks.length > 0
                              ? Colors.redAccent
                              : Colors.white.withOpacity(.1)),
                      splashRadius: 20,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              DrinkListView(
                drinks:
                    drinksModel.drinks.getRange(pageStart, pageEnd).toList(),
                key: ValueKey(page),
                selectable: editing,
                selectedDrinks: selectedDrinks,
                onSelect: (drink, selected) {
                  if (selected) {
                    selectedDrinks.add(drink);
                  } else {
                    selectedDrinks.remove(drink);
                  }
                  setState(() {});
                },
              ),
            ] else ...[
              const SizedBox(height: 10),
              Text(
                "You haven't added any drinks yet.",
                style: TextStyle(
                  color: Colors.white.withOpacity(.5),
                ),
              ),
              const SizedBox(height: 10),
              BetterTextButton(
                "Add Drink",
                onPressed: () => Get.toNamed("/add_drink"),
                padding: EdgeInsets.symmetric(horizontal: 15),
                color: Colors.white.withOpacity(.1),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
            Pagination(
              max: (drinksModel.drinks.length / itemsPerPage).ceil(),
              current: page,
              onChange: (value) {
                setState(() {
                  page = value;
                });
              },
            ),
          ],
        ),
      );
    });
  }
}
