import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/services/firebase_service.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';

class LoginController extends GetxController {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final obscureText = true.obs;
  final db = FirebaseFirestore.instance;
  final FirebaseService firebaseService = FirebaseService();
  final FirestoreService firestoreService = FirestoreService();

  @override
  Future<void> onReady() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      log(token ?? 'No Token');
    }
    super.onReady();
  }

  Future<void> signInWithEmailPassword() async {
    var isValid = formKey.currentState!.validate();
    if (isValid) {
      await firebaseService.execute(() async {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailCtrl.text, password: passwordCtrl.text);
        final uid = credential.user?.uid;
        final userDoc = <String, dynamic>{
          "lastLoggedInAt": FieldValue.serverTimestamp(),
        };
        await firestoreService.setDocument('users', uid, userDoc, merge: true);
      });
    }
  }

  Future<void> signInWithGoogle() async {
    safeCall(() async {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // cancelled

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final uid = userCredential.user?.uid;
      final userDoc = <String, dynamic>{
        "lastLoggedInAt": FieldValue.serverTimestamp(),
      };
      await firestoreService.setDocument('users', uid, userDoc, merge: true);
    });
  }


  static LoginController get to => Get.find();
}
