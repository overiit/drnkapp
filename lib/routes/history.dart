import 'dart:async';

import 'package:drnk/components/drink_listview.dart';
import 'package:drnk/components/pagination.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:drnk/utils/utils.dart';
import 'package:flutter/material.dart';

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
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' $info',
                        style: TextStyle(
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
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class History extends StatefulWidget {
  final List<Drink> drinks;

  const History({super.key, required this.drinks});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int itemsPerPage = 10;
  int page = 1;


  @override
  Widget build(BuildContext context) {
    int pageStart = ((page - 1) * itemsPerPage);
    int pageEnd = ((page - 1) * itemsPerPage) + itemsPerPage;
    if (pageEnd > widget.drinks.length) {
      pageEnd = widget.drinks.length;
    }
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: [
          DrinkListView(
            drinks: widget.drinks.getRange(pageStart, pageEnd).toList(),
            key: ValueKey(page),
          ),
          Pagination(
            max: (widget.drinks.length / itemsPerPage).ceil(),
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
  }
}
