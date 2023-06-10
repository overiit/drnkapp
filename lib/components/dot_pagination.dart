import 'package:flutter/material.dart';

class DotPagination extends StatelessWidget {
  final int page;
  final int maxPage;
  final Function(int) updatePage;
  final Color color;

  const DotPagination({
    super.key,
    required this.page,
    required this.maxPage,
    required this.updatePage,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxPage, (index) {
        return GestureDetector(
          onTap: () => updatePage(index),
          child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: page == index ? color : color.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        );
      }),
    );
  }
}