import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/resident_dashboard/constants/resident_dashboard_assets_constant.dart';
import 'package:kelola_kos/features/resident_dashboard/controllers/resident_dashboard_controller.dart';
import 'package:kelola_kos/utils/functions/resident_date_extension.dart';
import 'package:kelola_kos/utils/services/auth_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      'Halo, ${GlobalService.to.selectedResident.value!.name}',
                      style: Get.textTheme.headlineLarge,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        ResidentDashboardController.to.editName();
                      },
                      child: Text("Edit Nama"))
                ],
              ),
              8.verticalSpace,
              RichText(
                text: TextSpan(
                  text: 'Status Pembayaranmu: ',
                  style: Get.textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: GlobalService
                                  .to.selectedResident.value!.paymentStatus ==
                              true
                          ? 'Lunas'.tr
                          : 'Belum Lunas'.tr,
                      style: Get.textTheme.bodyLarge?.copyWith(
                        color: GlobalService
                                    .to.selectedResident.value!.paymentStatus ==
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
                'Waktu pembayaran berikutnya adalah: ${GlobalService.to.selectedResident.value!.getNextPaymentDateString()}',
                style: Get.textTheme.bodyLarge,
              ),
              24.verticalSpace,
              SizedBox(
                width: 1.sw,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.addResidentRoute, arguments: {
                      'resident': GlobalService.to.selectedResident.value,
                    });
                  },
                  child: Text(
                    'Edit data',
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: GlobalService
                          .to.selectedResident.value!.invoicePath?.isNotEmpty ??
                      false,
                  child: SizedBox(
                    width: 1.sw,
                    child: TextButton(
                      onPressed: () async {
                        final url = Uri.parse(
                            'https://orjhwzjkyynnhbpiexlw.supabase.co/storage/v1/object/public/${GlobalService
                                .to.selectedResident.value?.invoicePath}');
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: Text(
                        'Download invoice bulan ini',
                      ),
                    ),
                  ),
                ),
              ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
