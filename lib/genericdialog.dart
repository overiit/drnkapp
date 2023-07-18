import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:flutter/material.dart';

class GenericDialog extends StatelessWidget {
  Widget child;
  String helpText;
  String confirmText;
  String cancelText;

  GenericDialog({
    super.key,
    required this.child,
    required this.helpText,
    required this.confirmText,
    required this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(helpText),
          child,
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: BetterTextButton(
                  "CANCEL",
                  color: Colors.white.withOpacity(.1),
                  style: TextStyle(color: Colors.white.withOpacity(1)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BetterTextButton(
                  "OK",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
