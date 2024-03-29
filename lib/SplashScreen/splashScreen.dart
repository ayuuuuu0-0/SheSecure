import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:she_secure/HomeScreen/homeScreen.dart';
import 'package:she_secure/LoginScreen/login_screen.dart';
import 'package:she_secure/WelcomeScreen/welcomeScreen.dart';
import 'package:she_secure/mainTabView.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() async {
    Timer(const Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainTabView()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/splash.webp',
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1),
          ],
        ),
      ),
    );
  }
}
