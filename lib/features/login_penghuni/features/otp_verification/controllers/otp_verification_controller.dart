import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final otpCtrl = TextEditingController();
  final String verificationId = Get.arguments['verificationId'];

  @override
  void dispose() {
    otpCtrl.dispose();
    super.dispose();
  }

  Future<void> verifyOTP() async {
    final otp = otpCtrl.text.trim();
    log('OTP: $otp', name: 'OtpVerificationController');

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Verification Failed', e.message ?? 'Unknown error.');
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
  }

  static OtpVerificationController get to => Get.find();
}
