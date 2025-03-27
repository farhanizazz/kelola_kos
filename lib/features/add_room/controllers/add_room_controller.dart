import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_room/repositories/add_room_repository.dart';
import 'package:kelola_kos/features/detail_dorm/controllers/detail_dorm_controller.dart';
import 'package:kelola_kos/shared/models/room.dart';

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
        try {
          final res = await AddRoomRepository.updateRoom(
            dormId: Get.arguments['dormId'],
            room: Room(
              id: room.value!.id,
              dormId: room.value!.dormId,
              roomName: roomNameController.text,
              price: double.parse(priceController.text),
              notes: notesController.text,
              occupied: room.value!.occupied,
            ),
          );
          if (res.data['status']) {
            Get.back(result: true);
          }
        } catch (e, st) {
          log(e.toString());
          log(st.toString());
        }
      }
    }
  }

  Future<void> addRoom() async {
    final isValid = AddRoomController.to.validateForm();
    if (dormId.value == null) {
      if (isValid) {
        Get.back(
          result: Room(
            roomName: AddRoomController.to.roomNameController.text,
            price: double.parse(AddRoomController.to.priceController.text),
            notes: AddRoomController.to.notesController.text,
            occupied: false,
          ),
        );
      }
    } else {
      try {
        log("Before repository call");
        await AddRoomRepository.addRoom(
            dormId: int.parse(dormId.value!),
            rooms: [
              Room(
                  roomName: AddRoomController.to.roomNameController.text,
                  price:
                      double.parse(AddRoomController.to.priceController.text),
                  notes: AddRoomController.to.notesController.text,
                  occupied: false),
            ]);
        log("After repository call");
      } catch (e, st) {
        log(e.toString());
        log(st.toString());
      } finally {
        Get.delete<AddRoomController>();
        Get.back(result: true);
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
