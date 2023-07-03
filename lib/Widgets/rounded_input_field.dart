import 'package:flutter/material.dart';
import 'package:trueque_app/widgets/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final Color iconColor;
  final ValueChanged<String> onChanged;
  final TextInputType keyboard;

  RoundedInputField({
    required this.hintText,
    this.icon = Icons.person,
    this.iconColor = Colors.brown,
    required this.onChanged,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.brown,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: iconColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
        keyboardType: keyboard,
      ),
    );
  }
}

