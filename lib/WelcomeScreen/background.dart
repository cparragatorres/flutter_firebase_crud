import 'package:flutter/material.dart';

class WelcomeBackground1 extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry alignmentGeometry;
  const WelcomeBackground1({
    required this.child,
    this.alignmentGeometry = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(1.2, 0.2),
          colors: <Color>[
            Color(0xFF330f0e),
            Color(0xFF000000),
          ],
        ),
      ),
      height: size.height,
      width: size.width,
      child: child,
    );
  }
}

class WelcomeBackground2 extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry alignmentGeometry;
  WelcomeBackground2({
    required this.child,
    this.alignmentGeometry = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment(1.3, -0.3),
          colors: <Color>[
            Color(0xFFe05d1e),
            Color(0xFF280F09),
          ],
          stops: [0.0, 0.9],
        ),
      ),
      height: size.height,
      width: size.width,
      child: child,
    );
  }
}

class WelcomeBackground3 extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry alignmentGeometry;

  WelcomeBackground3({
    required this.child,
    this.alignmentGeometry = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFfcb406),
            Color(0xFFea594b),
          ],
        ),
      ),
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: alignmentGeometry,
        children: [
          child,
        ],
      ),
    );
  }
}
