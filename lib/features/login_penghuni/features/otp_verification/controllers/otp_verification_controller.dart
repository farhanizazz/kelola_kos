import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';

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

    safeCall(() async {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    });
  }

  static OtpVerificationController get to => Get.find();
}
