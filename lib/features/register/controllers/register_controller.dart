import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/shared/models/user.dart';
import 'package:kelola_kos/utils/services/firebase_service.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final obscureText = true.obs;
  final FirebaseService firebaseService = FirebaseService();
  final FirestoreService firestoreService = FirestoreService();

  Future<void> signUpUser() async {
    var isValid = formKey.currentState!.validate();
    if (isValid) {
      await firebaseService.execute(() async {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailCtrl.text,
          password: passwordCtrl.text,
        );
        firestoreService.setDocument('users', credential.user?.uid, FirestoreUser(
          email: emailCtrl.text,
          createdAt: Timestamp.now(),
          name: nameCtrl.text,
          fullName: fullNameCtrl.text,
          lastLoggedInAt: Timestamp.now(),
          phoneNumber: phoneCtrl.text,
          uid: credential.user?.uid ?? ''
        ).toMap());
      });
    }
  }

  static RegisterController get to => Get.find();
}
