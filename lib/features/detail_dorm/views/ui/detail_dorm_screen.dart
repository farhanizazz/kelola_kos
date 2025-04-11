import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/detail_dorm/constants/detail_dorm_assets_constant.dart';
import 'package:kelola_kos/features/detail_dorm/controllers/detail_dorm_controller.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/functions/price_format.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class DetailDormScreen extends StatelessWidget {
  DetailDormScreen({super.key});

  final assetsConstant = DetailDormAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              25.verticalSpace,
              Obx(
                () => Text(
                  DetailDormController.to.dorm.value?.name ?? '',
                  style: Get.textTheme.headlineLarge,
                ),
              ),
              16.verticalSpace,
              Obx(
                () => Text(
                  'Kapasitas: ${DetailDormController.to.room.length} Orang',
                  style: Get.textTheme.bodyMedium,
                ),
              ),
              24.verticalSpace,
              Text(
                "Penghuni",
                style: Get.textTheme.headlineSmall,
              ),
              Obx(() {
                final rooms = DetailDormController.to.room;
                if (rooms.isEmpty) {
                  return SizedBox(
                      height: 1.sh,
                      child: Center(child: CircularProgressIndicator()));
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
                            final resident = GlobalService.residents
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
                                      child: Text('Edit Kamar'),
                                    ),
                                    resident == null
                                        ? PopupMenuItem(
                                            value: 'delete',
                                            child: Text(
                                              'Hapus Kamar',
                                              style: TextStyle(
                                                  color: Get
                                                      .theme.colorScheme.error),
                                            ),
                                          )
                                        : PopupMenuItem(
                                            value: 'deleteResident',
                                            child: Text(
                                              'Hapus Penghuni',
                                              style: TextStyle(
                                                  color: Get
                                                      .theme.colorScheme.error),
                                            ),
                                          ),
                                  ],
                                );

                                if (selectedValue == 'editRoom') {
                                  try {
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
                                  } catch (e, st) {
                                    log(e.toString());
                                    log(st.toString());
                                  }
                                } else if (selectedValue == 'delete') {
                                  DetailDormController.to.deleteRoom(room.id!);
                                } else if (selectedValue == 'deleteResident') {
                                  DetailDormController.to
                                      .deleteResident(resident!.id);
                                }
                              },
                              child: ListTile(
                                onTap: () {
                                  log(GlobalService.residents.toString());
                                  Get.toNamed(Routes.addResidentRoute,
                                      arguments: {
                                        'dormId': room.dormId,
                                        'roomId': room.id,
                                        'resident': resident
                                      });
                                },
                                title: Text(resident != null
                                    ? resident.name
                                    : 'Tidak ada penghuni'),
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
                                              ? 'Lunas'
                                              : 'Belum dibayar'
                                          : 'Klik untuk mengisi kamar',
                                      style: Get.textTheme.bodySmall?.copyWith(
                                        color: resident != null
                                            ? resident.paymentStatus
                                                ? Get.theme.colorScheme.tertiary
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
                          try {
                            await DetailDormController.to.addRoom();
                          } catch (e, st) {
                            log(e.toString(), name: "Detail error");
                            log(st.toString(), name: "Detail ST");
                          }
                        },
                        child: Text("+ Kamar"),
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
    );
  }
}
