import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/utils/functions/normalize_phone_number.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/functions/show_error_bottom_sheet.dart';

class OtpVerificationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final otpCtrl = TextEditingController();
  String verificationId = Get.arguments['verificationId'];
  int? resendToken = Get.arguments['resendToken'];
  String phoneNumber = Get.arguments['phone'];
  RxInt resendCountdown = 0.obs;
  Timer? countdownTimer;

  @override
  void dispose() {
    otpCtrl.dispose();
    super.dispose();
  }

  void _startCountdown({int seconds = 60}) {
    resendCountdown.value = seconds;
    countdownTimer?.cancel(); // clear previous timer if any

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendCountdown.value <= 1) {
        timer.cancel();
      }
      resendCountdown.value--;
    });
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

  void resendOTP() async {
    if (resendCountdown.value > 0) return;

    _startCountdown();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: normalizePhoneNumber(phoneNumber),
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        log('Resend failed: ${e.message}');
        showErrorBottomSheet('Resend gagal:', '${e.message}');
      },
      codeSent: (String newVerificationId, int? newResendToken) {
        verificationId = newVerificationId;
        resendToken = newResendToken;
        log('OTP resent to $phoneNumber');
        Get.snackbar('OTP berhasil dikirim ulang', 'Silakan cek SMS Anda');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static OtpVerificationController get to => Get.find();
}
