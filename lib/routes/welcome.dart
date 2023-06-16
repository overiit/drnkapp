import 'package:drnk/components/buttons/OutlinedTextField.dart';
import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/components/dot_pagination.dart';
import 'package:drnk/components/terms.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:drnk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

List pagesData = [
  {
    "preTitle": "Meet your ultimate",
    "title": "Drinking Sidekick",
    "description":
        "Track drinks and alcohol levels effortlessly — our app offers the perfect tool for balanced, enjoyable nights out.",
  },
  {
    "preTitle": "Stir up your night with",
    "title": "Exciting Recipes",
    "description":
        "Discover a variety of delightful drink recipes, adding excitment and creativity to your nights out or cozy gatherings at home.",
  },
  {
    "preTitle": "Connect with your",
    "title": "Drinking Buddies",
    "description":
        "Team up with friends to track progress and share unforgettable drinking experiences together.",
  }
];

class _WelcomeState extends State<Welcome> {
  int page = 0;
  final PageController _pageController = PageController();
  bool welcomeForm = false;
  bool showTerms = false;

  // welcomeForm
  Sex sex = Sex.male;
  Weight weight = Weight(amount: 0, unit: WeightUnit.kg);

  @override
  Widget build(BuildContext context) {
    if (showTerms) {
      return SafeArea(
        child: Terms(
          onClose: () {
            setState(() {
              showTerms = false;
            });
          },
        ),
      );
    }
    bool formValid = weight.amount > 0;
    Widget activePage = NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.black, Colors.black.withOpacity(0)],
          stops: welcomeForm ? [.35, 1] : [.25, 1],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!welcomeForm)
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      page = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return WelcomePage(
                      preTitle: pagesData[index]['preTitle'],
                      title: pagesData[index]['title'],
                      description: pagesData[index]['description'],
                      page: index,
                      maxPage: pagesData.length,
                    );
                  },
                  itemCount: pagesData.length,
                ),
              ),
            if (welcomeForm)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    WelcomeForm(
                      sex: sex,
                      weight: weight,
                      updateSex: (Sex g) {
                        setState(() {
                          sex = g;
                        });
                      },
                      updateWeight: (Weight w) {
                        setState(() {
                          weight = w;
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                    // terms text with link
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        children: [
                          const TextSpan(
                            text: "By continuing, you agree to our ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text: "Terms of Service",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapAndPanGestureRecognizer()
                              ..onTapUp = (TapDragUpDetails details) {
                                setState(() {
                                  showTerms = true;
                                });
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (page < pagesData.length)
              DotPagination(
                page: page,
                maxPage: pagesData.length,
                updatePage: (newPage) {
                  setState(() {
                    page = newPage;
                  });
                  _pageController.animateToPage(page,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                },
              ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: BetterButton(
                      (page < pagesData.length) ? "Continue" : "Get Started",
                      onPressed: (page < pagesData.length || formValid)
                          ? () {
                              if (page < pagesData.length - 1) {
                                setState(() {
                                  page++;
                                });
                                _pageController.animateToPage(page,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                              } else if (page == pagesData.length - 1) {
                                setState(() {
                                  page += 1;
                                  welcomeForm = true;
                                });
                              } else {
                                UserProfileModel userProfile =
                                    Get.find<UserProfileModel>();
                                userProfile.sex = sex;
                                userProfile.weight = weight;
                                userProfile.update();
                              }
                            }
                          : null,
                      color: Colors.white.withOpacity(
                          (page < pagesData.length || formValid) ? 1 : 0.5),
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    return Stack(
      children: [
        WelcomeBackground(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: activePage,
          ),
        ),
      ],
    );
  }
}

class WelcomeForm extends StatelessWidget {
  final Weight weight;
  final Sex sex;
  final bool initialValues;
  final bool title;

  final Function(Sex) updateSex;
  final Function(Weight) updateWeight;

  const WelcomeForm({
    super.key,
    required this.updateSex,
    required this.updateWeight,
    required this.sex,
    required this.weight,
    this.initialValues = false,
    this.title = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (title)
          const Text(
            "Please enter your",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        if (title)
          const Text(
            "Details",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (title) const SizedBox(height: 20),
        const Row(
          children: [
            Text(
              "How much do you weigh?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: BetterTextField(
                isNumber: true,
                hintText: "Your Weight in ${capitalize(weight.unit.name)}",
                color: Colors.white,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                ),
                initialValue: initialValues ? weight.amount.toString() : "",
                onChanged: (value) {
                  double? amount = double.tryParse(value);
                  if (amount != null) {
                    updateWeight(Weight(amount: amount, unit: weight.unit));
                  } else {
                    updateWeight(Weight(amount: 0, unit: weight.unit));
                  }
                },
                padding: 5,
              ),
            ),
            const SizedBox(width: 10),
            BetterButton(
              "KG",
              color: Colors.transparent,
              borderColor: Colors.white
                  .withOpacity(weight.unit == WeightUnit.kg ? 1 : .5),
              style: TextStyle(
                color: Colors.white
                    .withOpacity(weight.unit == WeightUnit.kg ? 1 : .5),
              ),
              onPressed: () {
                updateWeight(convertWeight(weight, WeightUnit.kg));
              },
              padding: EdgeInsets.only(top: 15, bottom: 15),
            ),
            const SizedBox(width: 10),
            BetterButton(
              "LB",
              color: Colors.transparent,
              borderColor: Colors.white
                  .withOpacity(weight.unit == WeightUnit.lb ? 1 : .5),
              style: TextStyle(
                color: Colors.white
                    .withOpacity(weight.unit == WeightUnit.lb ? 1 : .5),
              ),
              onPressed: () {
                updateWeight(convertWeight(weight, WeightUnit.lb));
              },
              padding: EdgeInsets.only(top: 15, bottom: 15),
            )
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            Text(
              "What is your sex?",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: BetterButton(
                "Male",
                color: Colors.transparent,
                borderColor: Colors.white.withOpacity(sex == Sex.male ? 1 : .5),
                style: TextStyle(
                  color: Colors.white.withOpacity(sex == Sex.male ? 1 : .5),
                ),
                onPressed: () {
                  updateSex(Sex.male);
                },
                padding: EdgeInsets.only(top: 15, bottom: 15),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: BetterButton(
                "Female",
                color: Colors.transparent,
                borderColor:
                    Colors.white.withOpacity(sex == Sex.female ? 1 : .5),
                style: TextStyle(
                  color: Colors.white.withOpacity(sex == Sex.female ? 1 : .5),
                ),
                onPressed: () {
                  updateSex(Sex.female);
                },
                padding: EdgeInsets.only(top: 15, bottom: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WelcomeBackground extends StatelessWidget {
  Widget WelcomeImage(
      {double height = 200,
      required String path,
      bool topSide = false,
      bool leftSide = false,
      bool rightSide = false,
      bool bottomSide = false}) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(leftSide || topSide ? 0 : 20),
          topRight: Radius.circular(rightSide || topSide ? 0 : 20),
          bottomLeft: Radius.circular(leftSide || bottomSide ? 0 : 20),
          bottomRight: Radius.circular(rightSide || bottomSide ? 0 : 20),
        ),
        child: Image(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxHeight: MediaQuery.of(context).size.height,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                WelcomeImage(
                  height: 60,
                  path: 'lib/assets/welcome/welcome_3.png',
                  leftSide: true,
                  topSide: true,
                ),
                const SizedBox(height: 15),
                WelcomeImage(
                    height: 200,
                    path: 'lib/assets/welcome/welcome_6.png',
                    leftSide: true),
                const SizedBox(height: 15),
                WelcomeImage(
                    height: 200,
                    path: 'lib/assets/welcome/welcome_1.png',
                    leftSide: true),
                const SizedBox(height: 15),
                WelcomeImage(
                    height: 200,
                    path: 'lib/assets/welcome/welcome_4.png',
                    leftSide: true),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                WelcomeImage(
                  height: 169,
                  path: 'lib/assets/welcome/welcome_5.png',
                  topSide: true,
                ),
                const SizedBox(height: 15),
                WelcomeImage(
                    height: 200, path: 'lib/assets/welcome/welcome_6.png'),
                const SizedBox(height: 15),
                WelcomeImage(
                    height: 200, path: 'lib/assets/welcome/welcome_1.png'),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                WelcomeImage(
                  height: 120,
                  path: 'lib/assets/welcome/welcome_6.png',
                  rightSide: true,
                  topSide: true,
                ),
                const SizedBox(height: 15),
                WelcomeImage(
                    height: 200,
                    path: 'lib/assets/welcome/welcome_3.png',
                    rightSide: true),
                const SizedBox(height: 15),
                WelcomeImage(
                    height: 200,
                    path: 'lib/assets/welcome/welcome_5.png',
                    rightSide: true),
                const SizedBox(height: 15),
                WelcomeImage(
                    height: 200,
                    path: 'lib/assets/welcome/welcome_2.png',
                    rightSide: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final String preTitle;
  final String title;
  final String description;
  final int page;
  final int maxPage;

  const WelcomePage({
    super.key,
    required this.preTitle,
    required this.title,
    required this.description,
    this.page = 0,
    this.maxPage = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            preTitle,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
