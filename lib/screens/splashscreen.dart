import 'package:asubrix/screens/homepage.dart';
import 'package:asubrix/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/authservices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    AuthServices.isLoggedIn().then((value) {
      if (value) {
        Get.to(() => const HomeScreen());
      } else {
        Get.to(() => const LoginScreen());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.jpeg'),
      ),
    );
  }
}
