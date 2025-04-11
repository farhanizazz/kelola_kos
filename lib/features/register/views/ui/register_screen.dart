import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/register/constants/register_assets_constant.dart';
import 'package:kelola_kos/features/register/controllers/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final assetsConstant = RegisterAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: RegisterController.to.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.verticalSpace,
                Text(
                  "Daftar",
                  style: Get.textTheme.headlineLarge,
                ),
                14.verticalSpace,
                TextFormField(
                  controller: RegisterController.to.emailCtrl,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                12.verticalSpace,
                Obx(
                  () => TextFormField(
                    controller: RegisterController.to.passwordCtrl,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          RegisterController.to.obscureText(!RegisterController.to.obscureText.value);
                        },
                        icon: Icon(Icons.remove_red_eye_outlined),
                      ),
                    ),
        
                    obscureText: RegisterController.to.obscureText.value,
                    validator:(value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
        
                  ),
                ),
                12.verticalSpace,
                TextFormField(
                  controller: RegisterController.to.nameCtrl,
                  decoration: InputDecoration(
                    hintText: 'Nama',
                  ),
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                12.verticalSpace,
                TextFormField(
                  controller: RegisterController.to.fullNameCtrl,
                  decoration: InputDecoration(
                    hintText: 'Nama Lengkap',
                  ),
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                12.verticalSpace,
                TextFormField(
                  controller: RegisterController.to.phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '+627893920923',
                  ),
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                12.verticalSpace,
                FilledButton(
                  onPressed: () {
                    RegisterController.to.signUpUser();
                  },
                  child: Text('Daftar'),
                ),
                16.verticalSpace,
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    "Sudah punya akun? Masuk disini",
                    style: Get.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.normal
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
