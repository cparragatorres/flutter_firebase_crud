import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trueque_app/DialogBox/error_dialog.dart';
import 'package:trueque_app/DialogBox/loading_dialog.dart';
import 'package:trueque_app/ForgetPassword/forget_password.dart';
import 'package:trueque_app/HomeScreen/home_screen.dart';
import 'package:trueque_app/SignupScreen/signup_screen.dart';
import 'package:trueque_app/WelcomeScreen/background.dart';
import 'package:trueque_app/Widgets/already_have_an_Account_check.dart';
import 'package:trueque_app/widgets/rounded_input_field.dart';
import 'package:trueque_app/widgets/rounded_password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    showDialog(
        context: context,
        builder: (_) {
          return LoadingAlertDialog(message: "Espere por favor");
        });
    User? currentUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(message: error.message.toString());
          });
    });
    if (currentUser != null) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    } else {
      print("errorcito");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WelcomeBackground3(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: size.width * 0.8,
              ),
              RoundedInputField(
                hintText: "Email",
                onChanged: (value) {
                  _emailController.text = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              RoundedPasswordField(onChanged: (value) {
                _passwordController.text = value;
              }),
              const SizedBox(height: 8.0),
              MaterialButton(
                color: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  "Iniciar sesión",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
                      ? _login()
                      : showDialog(
                          context: context,
                          builder: (context) {
                            return const ErrorAlertDialog(message: "Por favor ingresa tu correo y contraseña para iniciar sesión");
                          },
                        );
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgetPassword(),
                      ));
                },
                child: const Text(
                  "¿Olvidaste tu contraseña?",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
                child: Container(width: size.width * 0.8, child: Divider(thickness: 2.0)),
              ),
              SizedBox(
                height: 16.0,
              ),
              AlreadyHaveAnAccountCheck(
                login: true,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
