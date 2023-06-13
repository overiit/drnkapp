import 'package:flutter/material.dart';

class BetterButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final TextStyle? style;
  final Color color;
  final Widget? child;
  final Color borderColor;
  final Color? overlayColor;
  final EdgeInsets padding;

  const BetterButton(
    this.text, {
    super.key,
    this.onPressed,
    this.color = Colors.white,
    this.style = const TextStyle(
      color: Colors.black,
    ),
    this.borderColor = Colors.transparent,
    this.overlayColor,
    this.padding = const EdgeInsets.all(0),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(padding),
        backgroundColor: MaterialStateProperty.all(color),
        overlayColor: MaterialStateProperty.all(
            overlayColor ?? Colors.black.withOpacity(.1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: borderColor, width: 2),
          ),
        ),
      ),
      child: child ??
          Text(
            text,
            style: style,
          ),
    );
  }
}
