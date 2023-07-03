import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {

  final Widget child;

  TextFieldContainer({
    required this.child,
});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(28),
      ),
      child: child,
    );
  }
}
