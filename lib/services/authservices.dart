import 'dart:developer';
import 'package:asubrix/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  static final _auth = FirebaseAuth.instance;
  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    log(googleSignIn.toString());

    // Check if the user is already signed in
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    log(credential.toString());
    return await _auth.signInWithCredential(credential);

    // return null;
  }

  static Future<UserCredential?> verifyOTP(
      {required String verificationId, required String otp}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    UserCredential? data;

    try {
      data = await _auth.signInWithCredential(credential);
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
    return data;
  }

  static Future loginWithPhoneNumber({required String phoneNumber}) async {
    String verificationid = "";
    verificationCompleted(PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    }

    verificationFailed(FirebaseAuthException exception) {
      Fluttertoast.showToast(msg: exception.message!);
      log(exception.message.toString());
    }

    codeSent(String verificationId, int? resendToken) async {
      verificationid = verificationId;
      Get.to(() => OTPVerificationScreen(
            verificationId: verificationid,
          ));
    }

    codeAutoRetrievalTimeout(String verificationId) {
      verificationId = verificationid;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  static Future<int> generateid() async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await usersCollection.get();
    return querySnapshot.size + 1;
  }

  static Future<void> storeUserData({User? user, String? name}) async {
    user ??= _auth.currentUser!;
    final uid = user.uid;

    final id = await generateid();

    final userData = {
      'id': id,
      'userId': uid,
      'name': name ?? user.displayName,
      'profile': user.photoURL
      // Add additional user data as needed
    };

    // Check if UID already exists
    bool uidExists = await isUidAlreadyExists(uid);

    if (uidExists) {
      log('User data already exists for UID: $uid');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData);

      debugPrint('User data stored successfully!');
    } catch (e) {
      debugPrint('Failed to store user data: $e');
    }
  }

  static Future<bool> isLoggedIn() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return await isUidAlreadyExists(currentUser.uid) ? true : false;
    }

    return currentUser != null;
  }

  static userLogOut() async {
    await _auth.signOut();
    Get.offAll(() => const LoginScreen());
  }

  static Future<bool> isUidAlreadyExists(String uid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: uid)
          .limit(1)
          .get();

      return querySnapshot.size > 0;
    } catch (e) {
      log('Error checking UID existence: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchUserData() async {
    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        log(userData.toString());
        return userData;
      } else {
        Get.offAll(() => const LoginScreen());
      }
    }).catchError((error) {
      debugPrint(error);
      return null;
    });
    return userdata;
  }
}
