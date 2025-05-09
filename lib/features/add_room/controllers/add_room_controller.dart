import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_room/repositories/add_room_repository.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/functions/show_error_bottom_sheet.dart';

class AddRoomController extends GetxController {
  static AddRoomController get to => Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final RxnString dormId = RxnString();
  final Rxn<Room> room = Rxn<Room>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      setRoom(Get.arguments['room']);
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (room.value != null) {
      roomNameController.text = room.value!.roomName;
      priceController.text = room.value!.price.toString();
      notesController.text = room.value!.notes;
    }
  }

  @override
  void dispose() {
    super.dispose();
    roomNameController.dispose();
    priceController.dispose();
    notesController.dispose();
  }

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      return true;
    }
    return false;
  }

  String? validateRoomName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama ruangan tidak boleh kosong';
    }
    return null;
  }

  void setDormId(String id) {
    dormId.value = id;
  }

  void setRoom(Room newRoom) {
    room.value = newRoom;
  }

  String? validateCapacity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kapasitas tidak boleh kosong';
    }
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return 'Masukkan kapasitas yang valid';
    }
    return null;
  }

  Future<void> editRoom() async {
    final isValid = AddRoomController.to.validateForm();
    if (Get.arguments != null) {
      if (isValid) {
        safeCall(() async {
          final res = await AddRoomRepository.updateRoom(
            dormId: Get.arguments['dormId'],
            room: Room(
              id: room.value!.id,
              dormId: room.value!.dormId,
              roomName: roomNameController.text,
              price: int.parse(priceController.text),
              notes: notesController.text,
            ),
          );
          Get.back(result: true);
        });
      }
    }
  }

  Future<void> addRoom() async {
    final isValid = AddRoomController.to.validateForm();
    if (isValid) {
      if (dormId.value == null) {
        Get.back(
          result: Room(
            roomName: AddRoomController.to.roomNameController.text,
            price: int.parse(AddRoomController.to.priceController.text),
            notes: AddRoomController.to.notesController.text,
          ),
        );
      } else {
        try {
          log("Before repository call");
          await AddRoomRepository.addRoom(
              dormId: dormId.value!,
              rooms: [
                Room(
                  roomName: AddRoomController.to.roomNameController.text,
                  price:
                      int.parse(AddRoomController.to.priceController.text),
                  notes: AddRoomController.to.notesController.text,
                ),
              ]);
          log("After repository call");
        } catch (e, st) {
          log(e.toString());
          log(st.toString());
          showErrorBottomSheet('Error', 'Terjadi kesalahan saat menambahkan kamar');
        } finally {
          Get.back(result: true);
        }
      }
    }
  }

  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Harga tidak boleh kosong';
    }
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Masukkan harga yang valid';
    }
    return null;
  }
}
