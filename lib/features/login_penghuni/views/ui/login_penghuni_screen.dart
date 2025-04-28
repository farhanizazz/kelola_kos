import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/login_penghuni/constants/login_penghuni_assets_constant.dart';
import 'package:kelola_kos/features/login_penghuni/controllers/login_penghuni_controller.dart';

class LoginPenghuniScreen extends StatelessWidget {
  LoginPenghuniScreen({Key? key}) : super(key: key);

  final assetsConstant = LoginPenghuniAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Form(
              key: LoginPenghuniController.to.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  25.verticalSpace,
                  Text(
                    'Login Penghuni',
                    style: Get.textTheme.headlineLarge,
                  ),
                  16.verticalSpace,
                  Text(
                    'Halo! Silahkan masukkan nomor teleponmu untuk login.',
                    style: Get.textTheme.bodyLarge,
                  ),
                  10.verticalSpace,
                  TextFormField(
                    controller: LoginPenghuniController.to.phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Nomor Telepon'),
                    validator:(value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor telepon tidak boleh kosong';
                      }
                      if (value.length < 10 || value.length > 13 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Nomor telepon tidak valid';
                      }
                      return null;
                    },
                  ),
                  24.verticalSpace,
                  SizedBox(
                    width: 1.sw,
                    child: Obx(
                      () => FilledButton(
                        onPressed: LoginPenghuniController.to.canSendMessage.value ? () async {
                          await LoginPenghuniController.to.signInWithPhone();
                        } : null,
                        child: Text('Masuk'.tr),
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "Masuk sebagai pemilik kos",
                      style: Get.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.normal
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
