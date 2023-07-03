import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Pages
import 'package:trueque_app/SplashScreen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.brown),
        title: 'Trueque',
        home: SplashScreen(),
      ),
    );
  }
}
