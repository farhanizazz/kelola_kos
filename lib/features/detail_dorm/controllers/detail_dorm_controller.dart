import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_room/controllers/add_room_controller.dart';
import 'package:kelola_kos/features/add_room/views/ui/add_room_screen.dart';
import 'package:kelola_kos/features/detail_dorm/repositories/detail_dorm_repository.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/shared/repositories/main_repository.dart';

class DetailDormController extends GetxController {
  final Rxn<Dorm> dorm = Rxn<Dorm>();
  final RxList<Room> room = <Room>[].obs;
  final String id = Get.arguments as String;

  @override
  void onInit() {
    log(id, name: "Detail dorm argument");
    // TODO: implement onInit
    _getDorm();
    _getRoom();
    super.onInit();
  }

  Future<void> _getRoom() async {
    try {
      room.value = await DetailDormRepository.getRoom(id);
      log(room.toString());
    } catch (e,st) {
      log(e.toString(), name: "Error");
      log(st.toString(), name: "Stacktrace");
    }
  }

  Future<void> _getDorm() async {
    try {
      dorm.value = await DetailDormRepository.getDorm(id);
      dorm.refresh();
    } catch (e,st) {
      log(e.toString(), name: "Error");
      log(st.toString(), name: "Stacktrace");
    }
  }

  Future<void> addRoom() async {
    Get.lazyPut(() => AddRoomController());
    AddRoomController.to.setDormId(DetailDormController.to.dorm.value!.id!);
    final result = await Get.bottomSheet<bool>(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: AddRoomScreen(),
      ),
      isScrollControlled: true,
    );
    Get.delete<AddRoomController>();
    log(result.toString(), name: "Result: ");
    if(result == true) {
      refresh();
    }
  }

  Future<void> deleteRoom(String roomId) async {
    final result = await MainRepository.deleteRoom(roomId);
    log(result.toString(), name: "Result: ");
    if(result) {
      refresh();
    }
  }

  Future<void> deleteResident(String residentId) async {
    await MainRepository.deleteResident(residentId);
  }

  @override
  void refresh() {
    _getRoom();
    super.refresh();
  }
  static DetailDormController get to => Get.find();
}
