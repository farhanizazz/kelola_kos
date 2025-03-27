import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_resident/repositories/add_resident_repository.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/shared/repositories/main_repository.dart';
import 'package:kelola_kos/shared/widgets/loading_bar.dart';
import 'package:kelola_kos/utils/functions/show_error_bottom_sheet.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class AddResidentController extends GetxController {
  final RxList<Dorm> dorms = GlobalService.dorms;
  final RxList<Room> rooms = <Room>[].obs;
  final RxString selectedDorm = ''.obs;
  final RxString selectedRoom = ''.obs;
  final TextEditingController residentNameController = TextEditingController();
  final TextEditingController residentPhoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dormController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final Map<String, dynamic> arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null) {
      arguments = Get.arguments;
    }
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    if (arguments['resident'] != null) {
      final Resident resident = arguments['resident'];
      residentNameController.text = resident.name;
      residentPhoneController.text = resident.phone;
    }
    if (arguments['dormId'] != null && arguments['roomId'] != null) {
      log(arguments.toString(), name: "Add resident argument");
      await changeDorm(arguments['dormId']);
      dormController.text =
          dorms.firstWhere((dorm) => dorm.id == arguments['dormId']!).name;
      changeRoom(arguments['roomId']);
      roomController.text =
          rooms.firstWhere((room) => room.id == arguments['roomId']!).roomName;
    }
  }

  Future<void> _getRoom(String roomId) async {
    try {
      Get.bottomSheet(
        const SizedBox(
          height: 150,
          child: LoadingBar(),
        ),
        isDismissible: false,
      );
      final allRoom = await GlobalService.fetchRooms(roomId);
      rooms.value = allRoom.where((room) {
        if (!room.occupied) {
          if(Get.arguments != null) {
            if(room.id == arguments['roomId']) {
              log(arguments['roomId'], name: "Selected room");
              return true;
            }
          }
          return true;
        }
        return false;
      }).toList();
      log(rooms.toString());
    } catch (e, st) {
      log(e.toString(), name: "Error");
      log(st.toString(), name: "Stacktrace");
      Get.back();
    }
  }

  Future<void> changeDorm(String id) async {
    selectedDorm.value = id;
    await _getRoom(id);
  }

  void changeRoom(String id) {
    selectedRoom.value = id;
  }

  String? validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kolom ini harus di isi';
    }
    return null;
  }

  bool _validateForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      return true;
    }
    return false;
  }

  Future<void> addResident() async {
    final resident = Resident(
      id: '',
      name: residentNameController.text,
      phone: residentPhoneController.text,
      roomId: selectedRoom.value,
      dormId: selectedDorm.value,
      paymentStatus: false,
    );
    if (_validateForm()) {
      if (selectedDorm.value == '' || selectedRoom.value == '') {
        showErrorBottomSheet(
            "Error", "Tolong pilih kos atau ruangan yang akan ditempati");
        return;
      }
      try {
        if (Get.arguments != null) {
          final Resident? resident = arguments['resident'];
          if (resident != null) {
            final response = await AddResidentRepository.updateResident(
              dormId: selectedDorm.value,
              roomId: selectedRoom.value,
              residentId: resident.id,
              resident: resident,
            );
            if (response.data['status'] == '200') {
              if (Get.isBottomSheetOpen != true) {
                Get.back();
              }
            }
          }
        } else {
          final response = await AddResidentRepository.addResident(
              selectedDorm.value, selectedRoom.value, resident);
          if (response.data['status'] == '200') {
            // GlobalService.refreshData();
            if (Get.isBottomSheetOpen != true) {
              Get.back();
            }
          }
        }
      } catch (e, st) {
        log(e.toString(), name: 'Add Resident Error');
        log(st.toString(), name: 'Stacktrace');
      }
    }
  }

  static AddResidentController get to => Get.find();
}
