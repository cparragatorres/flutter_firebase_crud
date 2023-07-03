import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trueque_app/DialogBox/error_dialog.dart';
import 'package:trueque_app/LoginScreen/login_screen.dart';
import 'package:trueque_app/WelcomeScreen/background.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _forgetPasswordController = TextEditingController(text: '');
  void _forgetPasswordSubmitForm() async{
    try{
      await _auth.sendPasswordResetEmail(email: _forgetPasswordController.text,);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
    }catch(error){
      ErrorAlertDialog(message: error.toString(),);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WelcomeBackground3(
        child: ListView(
          padding: EdgeInsets.all(40.0),
          children: [
            SizedBox(height: size.height * 0.02),
            const Text(
              "¿Olvidaste tu contraseña?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            ),
            SvgPicture.asset("assets/images/password-amico-dropped.svg", height: size.height * 0.5),
            Text(
              "Correo electrónico",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            TextField(
              controller: _forgetPasswordController,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.deepOrange,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                  hintText: "example@gmail.com",
                  hintStyle: TextStyle(color: Colors.white54)),
              style: const TextStyle(color: Colors.white),
            ),
            SizedBox(height: size.height * 0.05),
            MaterialButton(
              onPressed: () {
                _forgetPasswordSubmitForm();
              },
              color: Colors.brown,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  "Restrablecer ahora",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
