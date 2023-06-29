import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quicko/main.dart';
import 'package:quicko/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/animation_lj3lymkd.json'),
      centered: true,
      backgroundColor: Colors.blue,
      nextScreen: InitialScreen(),
      splashIconSize: 160,
      //splashTransition: SplashTransition.sizeTransition,
      //animationDuration: const Duration(seconds: 2),

    );
  }
}
