import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/resident_dashboard/constants/resident_dashboard_assets_constant.dart';
import 'package:kelola_kos/features/resident_dashboard/controllers/resident_dashboard_controller.dart';
import 'package:kelola_kos/utils/functions/resident_date_extension.dart';
import 'package:kelola_kos/utils/services/auth_service.dart';

class ResidentDashboardScreen extends StatelessWidget {
  ResidentDashboardScreen({Key? key}) : super(key: key);

  final assetsConstant = ResidentDashboardAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              12.verticalSpace,
              Text(
                'Halo, ${ResidentDashboardController.to.resident.name}',
                style: Get.textTheme.headlineLarge,
              ),
              8.verticalSpace,
              RichText(
                text: TextSpan(
                  text: 'Status Pembayaranmu: ',
                  style: Get.textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: ResidentDashboardController
                                  .to.resident.paymentStatus ==
                              true
                          ? 'Lunas'.tr
                          : 'Belum Lunas'.tr,
                      style: Get.textTheme.bodyLarge?.copyWith(
                        color: ResidentDashboardController
                                    .to.resident.paymentStatus ==
                                true
                            ? Get.theme.colorScheme.primary
                            : Get.theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
              8.verticalSpace,
              Text(
                'Waktu pembayaran berikutnya adalah: ${ResidentDashboardController.to.resident.getNextPaymentDateString()}',
                style: Get.textTheme.bodyLarge,
              ),
              24.verticalSpace,
              SizedBox(
                width: 1.sw,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Get.theme.colorScheme.error,
                  ),
                  onPressed: () {
                    AuthService.to.signOut();
                  },
                  child: Text(
                    'Logout',
                    style: Get.textTheme.bodyLarge?.copyWith(
                      color: Get.theme.colorScheme.error,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
