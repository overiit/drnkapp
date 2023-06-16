import 'package:drnk/components/nav.dart';
import 'package:drnk/components/topnav.dart';
import 'package:drnk/routes/add_drink.dart';
import 'package:drnk/routes/history.dart';
import 'package:drnk/routes/home.dart';
import 'package:drnk/routes/settings.dart';
import 'package:drnk/routes/settings/ProfileSex.dart';
import 'package:drnk/routes/settings/ProfileWeight.dart';
import 'package:drnk/routes/welcome.dart';
import 'package:drnk/store/stores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(MainApp());
}

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "DRNK",
      initialBinding: BindingsBuilder(
        () {
          Get.put(PreferenceModel());
          Get.put(UserProfileModel());
          Get.put(DrinksModel());
          // ...
          Get.put(DataLoader());
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
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case "/":
            builder = (context) => NavigatedPage(child: Home());
            break;
          case "/history":
            builder = (context) => NavigatedPage(child: History());
            break;
          case "/settings":
            builder = (context) => NavigatedPage(child: Settings());
            break;
          case "/add_drink":
            builder = (context) => NavigatedPage(child: AddDrink());
            break;
          case "/settings/profile/weight":
            builder =
                (context) => NavigatedPage(child: ProfileWeightSettings());
            break;
          case "/settings/profile/sex":
            builder = (context) => NavigatedPage(child: ProfileSexSettings());
            break;
          default:
            return null;
        }

        return NoAnimationPageRoute(
          builder: builder,
          settings: settings,
        );
      },
      onUnknownRoute: (settings) {
        return NoAnimationPageRoute(
          builder: (context) =>
              NavigatedPage(child: Text("404 Not Found: ${settings.name}")),
          settings: settings,
        );
      },
    );
  }
}

class NavigatedPage extends StatefulWidget {
  final Widget child;

  const NavigatedPage({super.key, required this.child});

  @override
  NavigatedPageState createState() => NavigatedPageState();
}

class NavigatedPageState extends State<NavigatedPage> {
  @override
  Widget build(BuildContext context) {
    DataLoader dataLoader = Get.find<DataLoader>();
    UserProfileModel profileModel = Get.find<UserProfileModel>();
    return Obx(() {
      if (!dataLoader.loaded) {
        return Loader();
      }
      if (profileModel.weight.amount == 0) {
        return Scaffold(
          body: Welcome(),
        );
      } else {
        return SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              print("Back button pressed!");
              Get.back();
              return false; // prevent Navigator.pop()
            },
            child: Scaffold(
              body: Column(
                children: [
                  TopNav(
                    onNavigate: (s) {},
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: widget.child,
                  ))
                ],
              ),
              bottomNavigationBar: Navigation(),
            ),
          ),
        );
      }
    });
  }
}

class NoAnimationPageRoute<T> extends PageRouteBuilder<T> {
  NoAnimationPageRoute({required this.builder, required RouteSettings settings})
      : super(
          settings: settings,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return builder(context);
          },
          transitionDuration: const Duration(milliseconds: 0),
        );

  final WidgetBuilder builder;
}
