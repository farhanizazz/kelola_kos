import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_room/controllers/add_room_controller.dart';
import 'package:kelola_kos/features/add_room/views/ui/add_room_screen.dart';
import 'package:kelola_kos/features/detail_dorm/repositories/detail_dorm_repository.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/shared/repositories/main_repository.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class DetailDormController extends GetxController {
  final Rxn<Dorm> dorm = Rxn<Dorm>();
  final RxList<Room> room = <Room>[].obs;
  final String id = Get.arguments as String;

  @override
  void onInit() {
    log(id, name: "Detail dorm argument");
    // TODO: implement onInit
    _getDorm();
    _bindRoomStream();
    super.onInit();
  }

  void _bindRoomStream() {
    room.bindStream(GlobalService.to.rooms.stream.map(
      (rooms) {
        log(rooms.toString(), name: "Room in detail dorm controller stream ");
        return rooms.where((r) => r.dormId == id).toList();
      },
    ));
    final latestRooms = GlobalService.to.rooms;
    room.value = latestRooms.where((r) => r.dormId == id).toList();
    log(GlobalService.to.rooms.toString(), name: "Room in detail dorm controller");
    log(id, name: "Dorm id in detail dorm controller");
  }

  Future<void> _getDorm() async {
    safeCall(() async {
      dorm.value = await DetailDormRepository.getDorm(id);
      dorm.refresh();
    });
  }

  Future<void> addRoom() async {
    Get.lazyPut(() => AddRoomController());
    AddRoomController.to.setDormId(DetailDormController.to.dorm.value!.id!);
    final result = await Get.bottomSheet<bool>(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: AddRoomScreen(),
      ),
      isScrollControlled: true,
    );
    Get.delete<AddRoomController>();
    log(result.toString(), name: "Result: ");
    if (result == true) {
      refresh();
    }
  }

  Future<void> deleteRoom(String roomId) async {
    final result = await MainRepository.deleteRoom(roomId);
    log(result.toString(), name: "Result: ");
  }

  Future<void> deleteResident(String residentId) async {
    await MainRepository.deleteResident(residentId);
  }

  @override
  void refresh() {
    super.refresh();
  }

  static DetailDormController get to => Get.find();
}
