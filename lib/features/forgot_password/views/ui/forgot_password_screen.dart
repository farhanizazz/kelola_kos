import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/forgot_password/constants/forgot_password_assets_constant.dart';
import 'package:kelola_kos/features/forgot_password/controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final assetsConstant = ForgotPasswordAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Form(
              key: ForgotPasswordController.to.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  25.verticalSpace,
                  Text(
                    'Lupa Password',
                    style: Get.textTheme.headlineLarge,
                  ),
                  16.verticalSpace,
                  Text(
                    'Masukkan email yang terdaftar untuk melakukan reset password.',
                    style: Get.textTheme.bodyLarge,
                  ),
                  10.verticalSpace,
                  TextFormField(
                    controller: ForgotPasswordController.to.emailCtrl,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator:(value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  12.verticalSpace,
                  SizedBox(
                    width: 1.sw,
                    child: FilledButton(
                      onPressed: () async {
                        await ForgotPasswordController.to.resetPassword();
                      },
                      child: Text('Kirim Email'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
