import 'package:flutter/material.dart';
import 'package:trueque_app/widgets/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final Color iconColor;


  RoundedPasswordField({
    required this.onChanged,
    this.iconColor = Colors.brown,
  });

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

bool obscureText = false;

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: !obscureText,
        onChanged: widget.onChanged,
        cursorColor: Colors.brown,
        decoration: InputDecoration(
          hintText: "Contraseña",
          icon: Icon(Icons.lock, color: widget.iconColor),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: widget.iconColor,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
