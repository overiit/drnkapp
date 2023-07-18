import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BetterTextField extends StatefulWidget {
  final Color? color;
  final TextStyle? style;
  final String hintText;
  final String initialValue;
  final double padding;
  final bool isNumber;
  final bool isEmail;
  final TextEditingController? controller;

  final Function(String)? onChanged;

  BetterTextField({
    super.key,
    this.color,
    this.padding = 0,
    this.style,
    required this.hintText,
    this.onChanged,
    this.initialValue = "",
    this.isNumber = false,
    this.isEmail = false,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() => BetterTextFieldState();
}

class BetterTextFieldState extends State<BetterTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      controller = widget.controller!;
      controller.text = widget.initialValue;
    } else {
      controller = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    Color color = widget.color ?? scheme.primary;
    TextStyle style = widget.style ??
        TextStyle(
          color: scheme.secondary,
        );
    TextInputType keyboardType = TextInputType.text;
    if (widget.isNumber) {
      keyboardType = TextInputType.numberWithOptions(decimal: true);
    } else if (widget.isEmail) {
      keyboardType = TextInputType.emailAddress;
    }
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: widget.onChanged,
      cursorColor: widget.color,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        constraints: BoxConstraints(
          maxHeight: 35 + (widget.padding * 2),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: color.withOpacity(0.7), fontSize: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: color, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }
}
