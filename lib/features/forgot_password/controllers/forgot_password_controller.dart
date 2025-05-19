import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/utils/services/firebase_service.dart';

class ForgotPasswordController extends GetxController {

  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    var isValid = formKey.currentState!.validate();
    if (isValid) {
      auth.sendPasswordResetEmail(email: emailCtrl.text);
    }
  }

  static ForgotPasswordController get to => Get.find();
}
