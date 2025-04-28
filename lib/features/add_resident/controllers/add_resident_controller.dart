import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_resident/repositories/add_resident_repository.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
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
  final TextEditingController paymentDateController = TextEditingController();
  final TextEditingController notificationIntervalController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool paymentStatus = false.obs;
  final RxBool isEdit = false.obs;
  final RxnInt payMonth = RxnInt(null);
  final RxnInt payDay = RxnInt(null);
  late final Map<String, dynamic> arguments;
  final Rx<Duration> notificationInterval = Duration(days: 30).obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null) {
      arguments = Get.arguments;
    }
    everAll([payDay, payMonth], (_)
    {
      // You might want to add a check to avoid 0 values (initial state)
      if (payDay.value != null && payMonth.value != null) {
        paymentDateController.text =
        "${AddResidentRepository.days[payDay.value!].toString().padLeft(2, '0')} ${AddResidentRepository.months[payMonth.value!]}";
      } else {
        paymentDateController.text = '';
      }
    });
    if (arguments['resident'] != null) {
      isEdit.value = true;
      final Resident resident = arguments['resident'];
      residentNameController.text = resident.name;
      residentPhoneController.text = resident.phone;
      paymentStatus.value = resident.paymentStatus;
      payDay.value = resident.paymentDay - 1;
      payMonth.value = resident.paymentMonth - 1;
      notificationInterval.value = resident.recurrenceInterval;
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

  Future<void> _getRoom(String dormId) async {
    try {
      rooms.value = GlobalService.rooms.where((room) {
        if (room.dormId != dormId) return false;
        if (Get.arguments != null) {
          if (arguments['resident'] != null) {
            final Resident? currentResident = arguments['resident'];
            if (currentResident!.roomId == room.id) {
              return true;
            }
          }
        }
        if (GlobalService.residents
            .where((resident) => resident.roomId == room.id)
            .isNotEmpty) return false;
        return true;
      }).toList();
      // rooms.value = allRoom.where((room) {
      //   if (GlobalService.isNotEmpty ?? false) {
      //     if(Get.arguments != null) {
      //       if(room.id == arguments['roomId']) {
      //         log(arguments['roomId'], name: "Selected room");
      //         return true;
      //       }
      //     }
      //     return true;
      //   }
      //   return false;
      // }).toList();
      log(rooms.toString(), name: 'Rooms');
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
    if (_validateForm()) {
      final resident = Resident(
        id: '',
        name: residentNameController.text,
        phone: residentPhoneController.text,
        roomId: selectedRoom.value,
        dormId: selectedDorm.value,
        paymentMonth: payMonth.value! + 1,
        paymentDay: payDay.value! + 1,
        paymentStatus: paymentStatus.value,
        recurrenceInterval: notificationInterval.value
      );
      if (selectedDorm.value == '' || selectedRoom.value == '') {
        showErrorBottomSheet(
            "Error", "Tolong pilih kos atau ruangan yang akan ditempati");
        return;
      }
      try {
        if (Get.arguments != null) {
          final Resident? currentResident = arguments['resident'];
          if (currentResident != null) {
            await AddResidentRepository.updateResident(
              dormId: selectedDorm.value,
              roomId: selectedRoom.value,
              residentId: currentResident.id,
              resident: resident,
            );
            Future.delayed(Duration(milliseconds: 300), () {
              Get.back();
            });
          } else {
            try {
              await AddResidentRepository.addResident(
                  selectedDorm.value, selectedRoom.value, resident);
              log('Sukses');
              Future.delayed(Duration(milliseconds: 300), () {
                Get.back();
              });
            } catch (e, st) {
              log(e.toString(), name: 'Add Resident Error');
              log(st.toString(), name: 'Stacktrace');
            }
          }
        } else {
          await AddResidentRepository.addResident(
              selectedDorm.value, selectedRoom.value, resident);
          if (Get.isBottomSheetOpen != true) {
            Get.back();
          }
        }
        GlobalService.residents.refresh();
      } catch (e, st) {
        log(e.toString(), name: 'Add Resident Error');
        log(st.toString(), name: 'Stacktrace');
      }
    }
  }

  static AddResidentController get to => Get.find();
}
