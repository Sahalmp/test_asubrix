import 'dart:developer';

import 'package:asubrix/Screens/Homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../services/authservices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/logo.jpeg', height: Get.height * 0.5),
          const SizedBox(
            height: 100,
          ),
          Column(
            children: [
              //Sign in with Google--------------------------------
              ExpandedButton(
                icon: SizedBox(
                  height: 25,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.network(
                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                    ),
                  ),
                ),
                text: "Google",
                color: Colors.blue,
                onpressed: handleGoogleSignin,
              ),

              //Sign in with phone
              ExpandedButton(
                icon: const Icon(Icons.phone),
                text: 'phone',
                color: Colors.green,
                onpressed: () {
                  Get.to(() => PhoneLoginScreen());
                },
              )
            ],
          )
        ],
      ),
    );
  }

  handleGoogleSignin() async {
    try {
      final UserCredential? data = await AuthServices.signInWithGoogle();
      log("object");

      if (data != null) {
        await AuthServices.storeUserData(user: data.user!);

        Get.to(() => const HomeScreen());
      }

      log(data.toString());
    } catch (e) {
      // Get.snackbar('Eror', "Cannott login with Google");
    }
  }
}

class ExpandedButton extends StatelessWidget {
  const ExpandedButton({
    super.key,
    this.icon,
    required this.text,
    required this.color,
    required this.onpressed,
  });
  final Widget? icon;
  final String text;
  final Function()? onpressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        icon: icon ?? const SizedBox(),
        onPressed: onpressed,
      ),
    );
  }
}

class PhoneLoginScreen extends StatelessWidget {
  PhoneLoginScreen({super.key});

  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Phone Login'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Phone Login',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                prefix: Text('+91'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16.0),
            ExpandedButton(
              onpressed: handleSendOtp,
              color: Colors.green,
              text: 'Send OTP',
            ),
          ],
        ),
      ),
    );
  }

  void handleSendOtp() async {
    await AuthServices.loginWithPhoneNumber(
        phoneNumber: "+91${_phoneNumberController.text.trim()}");
  }
}

class OTPVerificationScreen extends StatelessWidget {
  final String? verificationId;

  OTPVerificationScreen({super.key, this.verificationId});
  final TextEditingController verificationCodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: verificationCodeController,
              decoration: const InputDecoration(
                labelText: 'OTP',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ExpandedButton(
              onpressed: handleVerifyOtp,
              color: Colors.green,
              text: 'Verify OTP',
            ),
          ],
        ),
      ),
    );
  }

  void handleVerifyOtp() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (verificationCodeController.text.trim().length == 6) {
      final data = await AuthServices.verifyOTP(
          verificationId: verificationId ?? "",
          otp: verificationCodeController.text.trim());

      if (data != null) {
        final isexist = await AuthServices.isUidAlreadyExists(data.user!.uid);
        if (isexist) {
          Get.to(() => const HomeScreen());
        } else {
          Get.to(() => NamePage());
        }
        // AuthServices.storeUserData(data.user, "hello");
        log(data.toString());
      }
    } else {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
  }
}

class NamePage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  NamePage({super.key});

  void _submitName() async {
    String name = _nameController.text.trim();

    AuthServices.storeUserData(name: name)
        .then((value) => Get.to(() => const HomeScreen()));

    log('Submitted name: $name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please enter your name',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors
                    .grey[200], // Customize the text field background color
              ),
            ),
            const SizedBox(height: 24.0),
            ExpandedButton(
              onpressed: _submitName,
              color: Colors.green.shade800,
              text: 'Submit',
            ),
          ],
        ),
      ),
    );
  }
}
