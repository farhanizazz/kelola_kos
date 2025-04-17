import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/resident_list/constants/resident_list_assets_constant.dart';
import 'package:kelola_kos/features/resident_list/controllers/resident_list_controller.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/utils/functions/price_format.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class ResidentListScreen extends StatelessWidget {
  ResidentListScreen({super.key});

  final assetsConstant = ResidentListAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Tambah Penghuni".tr),
        onPressed: () {
          Get.toNamed(Routes.addResidentRoute);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              25.verticalSpace,
              SizedBox(
                width: 250,
                child: Text(
                  'Penghuni'.tr,
                  style: Get.textTheme.headlineLarge,
                ),
              ),
              25.verticalSpace,
              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ResidentListController.to.residents.length,
                  itemBuilder: (context, index) {
                    final Resident resident =
                        ResidentListController.to.residents[index];
                    return GestureDetector(
                      onLongPressStart: (details) async {
                        final RenderBox overlay = Overlay.of(context)
                            .context
                            .findRenderObject() as RenderBox;

                        final selectedValue = await showMenu(
                          context: context,
                          position: RelativeRect.fromRect(
                            details.globalPosition & Size(40, 40),
                            // Position where the user tapped
                            Offset.zero & overlay.size,
                          ),
                          items: [
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'Hapus Kamar'.tr,
                                style:
                                    TextStyle(color: Get.theme.colorScheme.error),
                              ),
                            ),
                          ],
                        );
                        if (selectedValue == 'delete') {
                          ResidentListController.to.deleteResident(
                            dormId: resident.dormId,
                            residentId: resident.id,
                          );
                        }
                      },
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(Routes.addResidentRoute, arguments: {
                            'roomId': resident.roomId,
                            'dormId': resident.dormId,
                            'resident': resident
                          });
                        },
                        subtitleTextStyle: Get.theme.textTheme.bodySmall,
                        contentPadding: EdgeInsets.zero,
                        title: Text(resident.name),
                        subtitle: Text(
                            "${GlobalService.dorms.firstWhere((dorm) => dorm.id == resident.dormId).name}, ${GlobalService.rooms.firstWhere((room) => room.id == resident.roomId).roomName}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              GlobalService.rooms.firstWhere((room) => room.id == resident.roomId).price.formatPrice(),
                              style: Get.textTheme.bodyLarge,
                            ),
                            Text(
                              resident.paymentStatus ? 'Lunas'.tr : 'Belum dibayar'.tr,
                              style: Get.textTheme.bodySmall?.copyWith(
                                  color: resident.paymentStatus
                                      ? Get.theme.colorScheme.tertiary
                                      : Get.theme.colorScheme.error),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
