import 'package:flutter/material.dart';
import 'package:trueque_app/LoginScreen/login_screen.dart';
import 'package:trueque_app/SignupScreen/signup_screen.dart';
import 'package:trueque_app/WelcomeScreen/background.dart';
import 'package:trueque_app/widgets/rounded_button.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: WelcomeBackground3(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                Image.asset('assets/images/logo.png', height: size.height * 0.4),
                SizedBox(height: size.height * 0.1),
                RoundedButton(
                  text: "LOGIN",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                ),
                RoundedButton(
                  text: "SIGN UP",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
