import 'package:flutter/material.dart';

class BetterTextField extends StatefulWidget {
  final Color color;
  final TextStyle style;
  final String hintText;
  final String initialValue;
  final double padding;
  final bool isNumber;
  final TextEditingController? controller;

  final Function(String)? onChanged;

  BetterTextField({
    super.key,
    required this.color,
    this.padding = 0,
    required this.style,
    required this.hintText,
    this.onChanged,
    this.initialValue = "",
    this.isNumber = false,
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
    return TextFormField(
      controller: controller,
      keyboardType: widget.isNumber
          ? TextInputType.numberWithOptions(decimal: true)
          : null,
      onChanged: widget.onChanged,
      cursorColor: widget.color,
      style: widget.style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        constraints: BoxConstraints(
          maxHeight: 35 + (widget.padding * 2),
        ),
        hintText: widget.hintText,
        hintStyle:
            TextStyle(color: widget.color.withOpacity(0.7), fontSize: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: widget.color, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: widget.color, width: 2),
        ),
      ),
    );
  }
}
