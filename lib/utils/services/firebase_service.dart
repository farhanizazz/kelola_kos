import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/shared/widgets/loading_bar.dart';
import 'package:kelola_kos/utils/functions/show_error_bottom_sheet.dart';

class FirebaseService extends GetxService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  /// Executes a Firebase action with automatic error handling
  Future<T?> execute<T>(Future<T> Function() action) async {
    try {
      Get.bottomSheet(
        const SizedBox(
          height: 150,
          child: LoadingBar(),
        ),
        isDismissible: false,
      );
      final res = await action();
      Get.back();
      return res;
    } on FirebaseAuthException catch (e) {
      Get.back();
      handleAuthError(e);
      return null;
    } catch (e, st) {
      Get.back();
      showErrorBottomSheet("An error occurred", e.toString());
      log("Error on FirebaseService", name: 'Error', error: e.toString());
      log(st.toString(), name: "Stacktrace");
      return null;
    }
  }

  /// Handles FirebaseAuth errors gracefully
  void handleAuthError(FirebaseAuthException e) {
    String errorMessage = "Something went wrong";
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = "Email sudah digunakan. Silakan gunakan email lain.";
        break;
      case 'invalid-email':
        errorMessage = "Format email tidak valid. Periksa kembali email Anda.";
        break;
      case 'operation-not-allowed':
        errorMessage = "Pendaftaran dengan email dan password tidak diizinkan.";
        break;
      case 'weak-password':
        errorMessage =
            "Kata sandi terlalu lemah. Gunakan kombinasi yang lebih kuat.";
        break;
      case 'too-many-requests':
        errorMessage =
            "Terlalu banyak percobaan login. Silakan coba lagi nanti.";
        break;
      case 'user-token-expired':
        errorMessage = "Sesi Anda telah berakhir. Silakan login kembali.";
        break;
      case 'network-request-failed':
        errorMessage =
            "Tidak ada koneksi internet. Mohon pastikan internet tersedia.";
        break;
      case 'invalid-credential':
        errorMessage = "Password atau Email salah, silakan coba lagi.";
        break;
      default:
        errorMessage = e.message ?? "Terjadi kesalahan yang tidak diketahui.";
    }
    log(e.code, name: "Error code");
    showErrorBottomSheet("Error", errorMessage);
  }
}
