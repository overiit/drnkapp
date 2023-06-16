import 'dart:async';

import 'package:drnk/components/dot_pagination.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Header extends StatefulWidget {
  @override
  HeaderState createState() => HeaderState();
}

class HeaderState extends State<Header> with TickerProviderStateMixin {
  double infoHeight = 0;
  double infoHeightStart = 0;
  double infoHeightEnd = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  final PageController _pageController = PageController();

  double bac = 0;
  int timeUntilSober = 0;

  void update() {
    DrinksModel drinksModel = Get.find<DrinksModel>();
    setState(() {
      if (drinksModel.drinks.isNotEmpty) {
        bac = calculateBac(drinksModel.drinks[0]);
        timeUntilSober = calculateTimeUntilSober(drinksModel.drinks[0]);
      } else {
        bac = 0;
        timeUntilSober = 0;
      }
    });
  }

  Timer? updateTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: 0, end: 82).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {
          infoHeight = _animation.value;
        });
      });
    update();
    updateTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        update();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    updateTimer?.cancel();
    super.dispose();
  }

  Widget headerPage({required String display, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 0),
              Row(
                children: [
                  Text(
                    display,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              // Container(height: 5, width: 50, color: Colors.blue),
              const SizedBox(height: 6.6),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 48,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    height: .8),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: const Image(
              image: AssetImage('lib/assets/bottle.png'),
            ),
          ),
        ),
      ],
    );
  }

  int page = 0;

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: GestureDetector(
        onTap: () {
          if (infoHeight == 0) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          width: double.infinity,
          height: 92,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    page = value;
                  });
                },
                itemBuilder: (context, index) {
                  String display = '---';
                  String value = '---';
                  if (index == 0) {
                    display = 'Alcohol Level';
                    value = '${bac.toStringAsFixed(3)} %';
                  } else if (index == 1) {
                    display = 'Time Until Sober';
                    value = timeSpanDuration(timeUntilSober);
                  }
                  return headerPage(display: display, value: value);
                },
                itemCount: 2,
              ),
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: DotPagination(
                  page: page,
                  maxPage: 2,
                  color: Colors.black,
                  updatePage: (newPage) {
                    setState(() {
                      page = newPage;
                    });
                    _pageController.animateToPage(page,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  },
                ),
              ),
              // A arrow icon to indicate that the user can tap on the header to expand it
              Positioned(
                right: 5,
                bottom: 0,
                child: Icon(
                  infoHeight > 42
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: Colors.black.withOpacity(.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfo() {
    HealthStatus healthStatus = bacHealthStatus(bac);
    return Container(
      height: infoHeight > 0 ? infoHeight + 114 : 0,
      padding: EdgeInsets.fromLTRB(15, infoHeight, 15, 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
            decoration: BoxDecoration(
              color: healthStatus.color.withOpacity(.17),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: healthStatus.color,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Possible Health Effects",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  healthStatus.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          buildInfo(),
          buildHeader(),
        ],
      ),
    );
  }
}
