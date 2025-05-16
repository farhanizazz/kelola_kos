import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/utils/functions/normalize_phone_number.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/functions/show_error_bottom_sheet.dart';
import 'package:kelola_kos/utils/services/firebase_service.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';

class LoginPenghuniController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  final firestoreClient = FirestoreService();
  final firebaseClient = FirebaseService();
  final RxBool canSendMessage = true.obs;

  @override
  void dispose() {
    phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> signInWithPhone() async {
    if (formKey.currentState!.validate()) {
      safeCall(() async {
        final normalizedPhone = normalizePhoneNumber(phoneCtrl.text);
        final doc =
            await firestoreClient.getDocument('Residents', normalizedPhone);
        if (doc == null) {
          showErrorBottomSheet('Error', 'Nomor telepon tidak terdaftar');
          return;
        }
        firebaseClient.execute(() async {
          canSendMessage.value = false;
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: normalizedPhone,
            verificationCompleted: (PhoneAuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              // Handle error (invalid number, quota exceeded, etc.)
              log('Phone verification failed: ${e.message}');
              showErrorBottomSheet('Verifikasi gagal:', '${e.message}');
              canSendMessage.value = true;
            },
            codeSent: (String verificationId, int? resendToken) {
              Get.toNamed(Routes.otpVerification, arguments: {
                'verificationId': verificationId,
                'resendToken': resendToken,
                'phone': phoneCtrl.text,
              });
              log('Code sent to ${phoneCtrl.text}',
                  name: 'LoginPenghuniController');
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              canSendMessage.value = true;
            },
          );
        });
      });
    }
  }

  static LoginPenghuniController get to => Get.find();
}
