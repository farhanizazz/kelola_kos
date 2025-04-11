import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/constants/asset_constant.dart';
import 'package:kelola_kos/features/login/constants/login_assets_constant.dart';
import 'package:kelola_kos/features/login/controllers/login_controller.dart';
import 'package:kelola_kos/shared/widgets/custom_tonal_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final assetsConstant = LoginAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Form(
              key: LoginController.to.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  25.verticalSpace,
                  Text(
                    'Login',
                    style: Get.textTheme.headlineLarge,
                  ),
                  16.verticalSpace,
                  Text(
                    'Halo! Tolong Login dengan akunmu dulu ya.',
                    style: Get.textTheme.bodyLarge,
                  ),
                  10.verticalSpace,
                  TextFormField(
                    controller: LoginController.to.emailCtrl,
                    decoration: InputDecoration(hintText: 'Email'),
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
                      controller: LoginController.to.passwordCtrl,
                      validator:(value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            LoginController.to.obscureText(!LoginController.to.obscureText.value);
                          },
                          icon: Icon(Icons.remove_red_eye_outlined),
                        ),
                      ),
                      obscureText: LoginController.to.obscureText.value,
                    ),
                  ),
                  10.verticalSpace,
                  SizedBox(
                    width: 1.sw,
                    child: FilledButton(
                      onPressed: () async {
                        await LoginController.to.signInWithEmailPassword();
                      },
                      child: Text('Masuk'),
                    ),
                  ),
                  10.verticalSpace,
                  SizedBox(
                    width: 1.sw,
                    child: TonalButton(
                      onPressed: () async {
                        await LoginController.to.signInWithGoogle();
                      },
                      child: Text('Masuk Dengan Google'),
                      icon: SvgPicture.asset(AssetConstant.icGoogle),
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    'Lupa password?',
                    style: Get.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.normal
                    ),
                  ),
                  12.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.registerRoute);
                    },
                    child: Text(
                      "Belum punya akun? Daftar",
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
