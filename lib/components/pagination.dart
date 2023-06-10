import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int max;
  final int current;
  final Function(int) onChange;

  const Pagination({
    Key? key,
    required this.max,
    required this.current,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int start = current - 2;
    if (start < 1) start = 1;

    if (max == 1) {
      return Container();
    }

    int end = current + 2;
    if (end > max) end = max;

    List<Widget> pages = [];
    for (int index = 0; index < end - start + 1; index++) {
      int page = start + index;

      // Add the gap between the page numbers
      if (index > 0) {
        pages.add(const SizedBox(width: 8));
      }

      pages.add(
        Ink(
          decoration: ShapeDecoration(
            color: Colors.white.withOpacity(.1),
            shape: const CircleBorder(),
          ),
          child: InkWell(
            onTap: () => onChange(page),
            customBorder: CircleBorder(),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Text(
                '$page',
                style: TextStyle(
                  color: current == page ? Colors.white : Colors.white.withOpacity(.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget arrowButton(String text, void Function()? onTap) {
      return Ink(
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(.1),
          shape: const CircleBorder(),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: CircleBorder(),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: Text(
              text,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // arrowButton('<', current > 1 ? () => onChange(current - 1) : null),
          Row(children: pages),
          // arrowButton('>', current < max ? () => onChange(current + 1) : null),
        ],
      ),
    );
  }
}