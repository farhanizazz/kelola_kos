import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/constants/asset_constant.dart';
import 'package:kelola_kos/features/profile/constants/profile_assets_constant.dart';
import 'package:kelola_kos/features/profile/controllers/profile_controller.dart';
import 'package:kelola_kos/shared/widgets/custom_tonal_button.dart';
import 'package:kelola_kos/utils/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final assetsConstant = ProfileAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            25.verticalSpace,
            Text(
              'Profile',
              style: Get.textTheme.headlineLarge,
            ),
            14.verticalSpace,
            TextField(
              decoration: const InputDecoration(hintText: "Nama"),
              controller: ProfileController.to.nameCtrl,
            ),
            16.verticalSpace,
            TextField(
              decoration: const InputDecoration(hintText: "Nama lengkap"),
              controller: ProfileController.to.fullNameCtrl,
            ),
            16.verticalSpace,
            TextField(
              decoration: const InputDecoration(hintText: "Email"),
              controller: ProfileController.to.emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            12.verticalSpace,
            TextField(
              decoration: const InputDecoration(
                hintText: "Nomor Telepon",
              ),
              controller: ProfileController.to.phoneCtrl,
              keyboardType: TextInputType.phone,
            ),
            12.verticalSpace,
            TextField(
              decoration: InputDecoration(
                hintText: "Bahasa",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SvgPicture.asset(
                      height: 30,
                      Get.locale == Locale('id', 'ID') ? AssetConstant.icIndoFlag : AssetConstant.icEngFlag,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              controller: ProfileController.to.languageCtrl,
              onTap: () {
                ProfileController.to.changeLanguage(context);
              },
              readOnly: true,
            ),
            12.verticalSpace,
            FilledButton(
                onPressed: () {
                  ProfileController.to.updateProfile();
                },
                child: const Text("Update Profile")),
            // 48.verticalSpace,
            // Text(
            //   'Setting Akun',
            //   style: Get.textTheme.headlineMedium
            //       ?.copyWith(fontWeight: FontWeight.w600),
            // ),
            // 16.verticalSpace,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Terima Notifikasi',
            //       style: Get.textTheme.headlineSmall
            //           ?.copyWith(fontWeight: FontWeight.w600),
            //     ),
            //     Obx(
            //         () => Switch(value: ProfileController.to.notificationStatus.value, onChanged: (value) {
            //         ProfileController.to.notificationStatus.value = !ProfileController.to.notificationStatus.value;
            //       }),
            //     )
            //   ],
            // ),
            // 40.verticalSpace,
            // FilledButton(
            //   style: FilledButton.styleFrom(
            //       backgroundColor: Get.theme.colorScheme.error),
            //   onPressed: () {},
            //   child: Text(
            //     "Hapus Akun",
            //     style: TextStyle(color: Get.theme.colorScheme.onError),
            //   ),
            // ),
            12.verticalSpace,
            TonalButton(
              onPressed: () {
                AuthService.to.signOut();
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Get.theme.colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
