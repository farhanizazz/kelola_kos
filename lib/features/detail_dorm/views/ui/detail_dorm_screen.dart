import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/detail_dorm/constants/detail_dorm_assets_constant.dart';
import 'package:kelola_kos/features/detail_dorm/controllers/detail_dorm_controller.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/functions/price_format.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class DetailDormScreen extends StatelessWidget {
  DetailDormScreen({super.key});

  final assetsConstant = DetailDormAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                25.verticalSpace,
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios_new),
                    ),
                    Obx(
                      () => Text(
                        DetailDormController.to.dorm.value?.name ?? '',
                        style: Get.textTheme.headlineLarge,
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                Obx(
                  () => Text(
                    '${'Kapasitas'.tr}: ${DetailDormController.to.room.length} ${'Orang'.tr}',
                    style: Get.textTheme.bodyMedium,
                  ),
                ),
                24.verticalSpace,
                Text(
                  "Penghuni".tr,
                  style: Get.textTheme.headlineSmall,
                ),
                Obx(() {
                  final rooms = DetailDormController.to.room;
                  if (rooms.isEmpty) {
                    return Column(
                      children: [
                        12.verticalSpace,
                        FilledButton(
                          onPressed: () async {
                            safeCall(() async {
                              await DetailDormController.to.addRoom();
                            });
                          },
                          child: Text("+ ${'Kamar'.tr}"),
                        ),
                        12.verticalSpace,
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: rooms.length, // This is safe now
                          itemBuilder: (context, index) {
                            final Room room = rooms[index];
                            return Obx(() {
                              final resident = GlobalService.to.residents
                                  .firstWhereOrNull((r) => r.roomId == room.id);
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
                                        value: 'editRoom',
                                        child: Text('Edit Kamar'.tr),
                                      ),
                                      resident == null
                                          ? PopupMenuItem(
                                              value: 'delete',
                                              child: Text(
                                                'Hapus Kamar'.tr,
                                                style: TextStyle(
                                                    color: Get.theme.colorScheme
                                                        .error),
                                              ),
                                            )
                                          : PopupMenuItem(
                                              value: 'deleteResident',
                                              child: Text(
                                                'Hapus Penghuni'.tr,
                                                style: TextStyle(
                                                    color: Get.theme.colorScheme
                                                        .error),
                                              ),
                                            ),
                                    ],
                                  );

                                  if (selectedValue == 'editRoom') {
                                    safeCall(() async {
                                      final result = await Get.toNamed(
                                          Routes.addRoomRoute,
                                          arguments: {
                                            'dormId': room.dormId,
                                            'room': room,
                                          });
                                      log(result.toString(), name: "Result");
                                      if (result == true) {
                                        DetailDormController.to.refresh();
                                      }
                                    });
                                  } else if (selectedValue == 'delete') {
                                    DetailDormController.to
                                        .deleteRoom(room.id!);
                                  } else if (selectedValue ==
                                      'deleteResident') {
                                    DetailDormController.to
                                        .deleteResident(resident!.id);
                                  }
                                },
                                child: ListTile(
                                  onTap: () {
                                    log(GlobalService.to.residents.toString());
                                    Get.toNamed(Routes.addResidentRoute,
                                        arguments: {
                                          'dormId': room.dormId,
                                          'roomId': room.id,
                                          'resident': resident
                                        });
                                  },
                                  title: Text(resident != null
                                      ? resident.name
                                      : 'Tidak ada penghuni'.tr),
                                  contentPadding: EdgeInsets.zero,
                                  subtitle: Text(room.roomName),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(room.price.formatPrice(),
                                          style: Get.textTheme.bodyLarge),
                                      Text(
                                        resident != null
                                            ? resident.paymentStatus
                                                ? 'Lunas'.tr
                                                : 'Belum dibayar'.tr
                                            : 'Klik untuk mengisi kamar'.tr,
                                        style:
                                            Get.textTheme.bodySmall?.copyWith(
                                          color: resident != null
                                              ? resident.paymentStatus
                                                  ? Get.theme.colorScheme
                                                      .tertiary
                                                  : Get.theme.colorScheme.error
                                              : Get.theme.disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                        4.verticalSpace,
                        FilledButton(
                          onPressed: () async {
                             safeCall(() async {
                              await DetailDormController.to.addRoom();
                            });
                          },
                          child: Text("+ ${"Kamar".tr}"),
                        ),
                        12.verticalSpace,
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
