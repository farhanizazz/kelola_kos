import 'package:get/get.dart';
import 'package:kelola_kos/features/login_penghuni/features/otp_verification/controllers/otp_verification_controller.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OtpVerificationController());
  }
}