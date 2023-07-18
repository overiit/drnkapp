import 'package:flutter/material.dart';

class BetterTextButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final TextStyle? style;
  final Color? color;
  final IconData? icon;
  final Widget? child;
  final Color borderColor;
  final Color? overlayColor;
  final EdgeInsets padding;

  const BetterTextButton(
    this.text, {
    super.key,
    this.icon,
    this.onPressed,
    this.color,
    this.style,
    this.borderColor = Colors.transparent,
    this.overlayColor,
    this.padding = const EdgeInsets.all(0),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    Color color = this.color ?? scheme.primary;
    TextStyle style = this.style ??
        TextStyle(color: scheme.secondary, fontWeight: FontWeight.w900);
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
          (icon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: style.color,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      text,
                      style: style,
                    )
                  ],
                )
              : Text(
                  text,
                  style: style,
                )),
    );
  }
}
