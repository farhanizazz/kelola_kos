import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/shared/models/user.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LocalStorageService extends GetxService {
  LocalStorageService._();

  static final box = Hive.box("venturo");

  /// Kode untuk setting localstorage sesuai dengan repository
  static Future<void> setAuth(
      FirestoreUser userData) async {
    await box.put(LocalStorageConstant.USER_ID, userData.uid);
    await box.put(LocalStorageConstant.NAME, userData.name);
    await box.put(LocalStorageConstant.FULLNAME, userData.fullName);
    await box.put(LocalStorageConstant.PHONE, userData.phoneNumber);
    await box.put(LocalStorageConstant.EMAIL, userData.email);
    log("success", name: "SetAuth status");
  }

  static Future deleteAuth() async {
    box.clear();
    log("success", name: "deleteAuth status");
  }
}
