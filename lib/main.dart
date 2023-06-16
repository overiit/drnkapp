import 'dart:async';
import 'package:drnk/components/nav.dart';
import 'package:drnk/components/terms.dart';
import 'package:drnk/components/topnav.dart';
import 'package:drnk/routes/add_drink.dart';
import 'package:drnk/routes/history.dart';
import 'package:drnk/routes/home.dart';
import 'package:drnk/routes/settings.dart';
import 'package:drnk/routes/welcome.dart';
import 'package:drnk/store/preferences.dart';
import 'package:drnk/store/storage.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainApp> {
  late Future<void> loader;

  UserProfile? userProfile;
  List<Drink> drinks = [];

  Future<void> load() async {
    userProfile = await loadItem(storageUserProfileKey, UserProfile.fromMap);
    drinks = await loadList(storageDrinkListKey, Drink.fromMap);
    PreferenceModel currentPreferenceModel = Get.find<PreferenceModel>();
    await loadItem("preferences", currentPreferenceModel.overrideFromMap);
  }

  updateUserProfile(UserProfile? userProfile) {
    setState(() {
      this.userProfile = userProfile;
      saveItem(storageUserProfileKey, userProfile);
    });
  }

  @override
  void initState() {
    super.initState();

    loader = load();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "DRNK",
      initialBinding: BindingsBuilder(
        () {
          Get.put(PreferenceModel());
        },
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF181818),
        colorScheme: const ColorScheme.dark(
          primary: Colors.black,
          secondary: Colors.blue,
        ),
        fontFamily: 'Inter',
        fontFamilyFallback: const ['Roboto'],
      ),
      home: FutureBuilder(
        future: loader,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (userProfile == null) {
              return Scaffold(
                body: Welcome(
                  updateUserProfile: updateUserProfile,
                ),
              );
            }
            return MainNav(
              userProfile: userProfile,
              drinks: drinks,
              updateUserProfile: updateUserProfile,
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class MainNav extends StatefulWidget {
  final UserProfile? userProfile;
  final List<Drink> drinks;
  final Function(UserProfile?) updateUserProfile;

  const MainNav(
      {super.key,
      this.userProfile,
      required this.drinks,
      required this.updateUserProfile});

  @override
  MainNavState createState() => MainNavState();
}

class MainNavState extends State<MainNav> {
  List<String> history = [];
  String activeRoute = "/";
  List<Drink> drinks = [];

  Timer? updateTimer;

  @override
  void initState() {
    super.initState();

    drinks = widget.drinks;
  }

  @override
  void dispose() {
    super.dispose();
    updateTimer?.cancel();
  }

  void onNavigate(route) {
    history.add(route);
    setState(() {
      activeRoute = route;
    });
  }

  void createDrink(Drink drink) {
    if (widget.userProfile == null) {
      return;
    }
    setState(() {
      drinks = addDrink(widget.userProfile!, drinks, drink);
      activeRoute = "/";
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget routeWidget;

    switch (activeRoute) {
      case "/":
        routeWidget = Home(
          onNavigate: onNavigate,
          drinks: drinks,
        );
        break;
      case "/history":
        routeWidget = History(drinks: drinks);
        break;
      case "/insights":
        routeWidget = Text("Insights Coming Soon");
        break;
      case "/settings":
        routeWidget = Settings(
          userProfile: widget.userProfile!,
          updateUserProfile: widget.updateUserProfile,
        );
        break;
      case "/terms":
        routeWidget = Terms();
        break;
      case "/add_drink":
        routeWidget = AddDrink(createDrink: createDrink);
      default:
        routeWidget = Text("404");
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TopNav(
              onNavigate: onNavigate,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: routeWidget,
            ))
          ],
        ),
        bottomNavigationBar: Navigation(
          activeRoute: activeRoute,
          onNavigate: onNavigate,
        ),
      ),
    );
  }
}
