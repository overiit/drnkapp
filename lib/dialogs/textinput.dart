import 'package:drnk/components/buttons/OutlinedTextField.dart';
import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/genericdialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<String?> showTextInputDialog({
  required BuildContext context,
  required String initialValue,
  TransitionBuilder? builder,
  bool useRootNavigator = true,
  TextInputType? keyboardType,
  String helpText = "Enter a value",
  String cancelText = "CANCEL",
  String confirmText = "OK",
  String hintText = "Enter a value",
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  Orientation? orientation,
}) async {
  final TextEditingController controller = TextEditingController();

  final Widget dialog = GenericDialog(
    helpText: helpText,
    confirmText: confirmText,
    cancelText: cancelText,
    child: BetterTextField(
      controller: TextEditingController(text: initialValue),
      hintText: hintText,
      color: Colors.white,
      style: TextStyle(color: Colors.red),
    ),
  );

  return await showDialog<String?>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Text Input Dialog'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter your text here',
            filled: true,
            fillColor: Theme.of(context).dialogBackgroundColor,
          ),
        ),
        actions: <Widget>[
          BetterTextButton(
            'cancel',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          BetterTextButton(
            'ok',
            onPressed: () {
              print(controller.text); // Here is the entered text
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}
