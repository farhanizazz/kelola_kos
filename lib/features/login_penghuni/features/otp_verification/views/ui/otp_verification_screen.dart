import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/login_penghuni/features/otp_verification/constants/otp_verification_assets_constant.dart';
import 'package:kelola_kos/features/login_penghuni/features/otp_verification/controllers/otp_verification_controller.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({Key? key}) : super(key: key);

  final assetsConstant = OtpVerificationAssetsConstant();
  final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ));

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Verifikasi',
              style: Get.theme.textTheme.headlineLarge,
            ),
            28.verticalSpace,
            Text(
              'Masukkan kode yang dikirim ke nomor',
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                  color:
                      Get.theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  fontWeight: FontWeight.w500),
            ),
            14.verticalSpace,
            Text(
              Get.arguments['phone'],
              style: Get.theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            Spacer(
              flex: 1,
            ),
            Align(
              alignment: Alignment.center,
              child: Pinput(
                onCompleted: (value) {
                  OtpVerificationController.to.verifyOTP();
                },
                controller: OtpVerificationController.to.otpCtrl,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration?.copyWith(
                    border: Border.all(
                        color: Get.theme.colorScheme.primary, width: 2),
                  ),
                ),
                followingPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration?.copyWith(
                    color: Get.theme.colorScheme.surfaceContainerLow,
                  ),
                ),
                length: 6,
              ),
            ),
            28.verticalSpace,
            Text(
              'Kode tidak diterima?',
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                  color:
                      Get.theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  fontWeight: FontWeight.w500),
            ),
            Obx(
                () => TextButton(
                onPressed: OtpVerificationController.to.resendCountdown.value > 0 ? null : () {
                  OtpVerificationController.to.resendOTP();
                },
                child: Text(
                  'Kirim ulang kode ${OtpVerificationController.to.resendCountdown.value > 0 ? '(${OtpVerificationController.to.resendCountdown.value}s)' : ''}',
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                      color: !(OtpVerificationController.to.resendCountdown.value > 0) ? Get.theme.colorScheme.primary : Get.theme.disabledColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Spacer(
              flex: 5,
            )
          ],
        ),
      ),
    );
  }
}
