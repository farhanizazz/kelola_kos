import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/add_dorm/repositories/add_dorm_repository.dart';
import 'package:kelola_kos/features/add_room/bindings/add_room_binding.dart';
import 'package:kelola_kos/features/add_room/controllers/add_room_controller.dart';
import 'package:kelola_kos/features/add_room/repositories/add_room_repository.dart';
import 'package:kelola_kos/features/add_room/views/ui/add_room_screen.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/shared/repositories/main_repository.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class AddDormController extends GetxController {
  final TextEditingController dormNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<Room> rooms = <Room>[].obs;
  late final Dorm arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null) {
      arguments = Get.arguments;
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    if (Get.arguments != null) {
      dormNameController.text = arguments.name;
      locationController.text = arguments.location;
      noteController.text = arguments.note ?? '';
      rooms.assignAll(arguments.rooms);
    }
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    dormNameController.dispose();
    locationController.dispose();
    noteController.dispose();
    super.onClose();
  }

  Future<void> addRoom() async {
    Get.lazyPut(() => AddRoomController());
    final Room? newRoom = await Get.bottomSheet<Room>(
        Container(
          height: Get.height * 0.8,
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: AddRoomScreen(),
        ),
        isScrollControlled: true);

    if (newRoom != null) {
      rooms.add(newRoom);
    } else {
      print("User canceled adding a room");
    }
  }

  Future<void> editRoom(int index) async {
    Get.lazyPut(() => AddRoomController());
    AddRoomController.to.setRoom(rooms[index]);
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
    log(result.toString(), name: "Result: ");
    if(result == true) {
      refresh();
    }
  }

  String? validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kolom ini harus di isi';
    }
    return null;
  }

  String? validateImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kolom ini harus diisi';
    }
    const urlPattern = r'^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:\d+)?(\/.*\.(png|jpg|jpeg|gif|bmp|webp))$';
    final regex = RegExp(urlPattern, caseSensitive: false);

    if (!regex.hasMatch(value)) {
      return 'Masukkan URL gambar yang valid (PNG, JPG, JPEG, GIF, BMP, atau WEBP)';
    }

    return null;
  }



  bool _validateForm() {
    log('Form State: ${formKey.currentState}');
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      return true;
    }
    return false;
  }

  Future<void> addDorm() async {
    final validate = _validateForm();
    if (validate == true) {
      try {
        if (Get.arguments != null) {
          log("Update", name: "Add Dorm Status");
          final dormId = arguments.id!;
          final dormRes = await AddDormRepository.updateDorm(
            data: {
              'name': dormNameController.text,
              'location': locationController.text,
              'note': noteController.text,
            },
            dormId: dormId,
          );
          Get.back();
          return;
        }
        final dormRes = await AddDormRepository.addDorm({
          'name': dormNameController.text,
          'location': locationController.text,
          'note': noteController.text,
          'image': imageUrlController.text,
        });
        final dormId = dormRes.data['id'];
        final roomRes = await AddRoomRepository.addRoom(
            dormId: int.parse(dormId), rooms: rooms);
        // GlobalService.refreshData();
        if (Get.isBottomSheetOpen != true) {
          Get.back();
        }
      } catch (e, st) {
        log(e.toString());
      }
    }
  }

  Future<void> deleteRoom(int index) async {
    if(Get.arguments == null) {
      if (index < 0 || index >= rooms.length) return;

      Future.delayed(300.ms, () {
        if (index < rooms.length) {
          rooms.removeAt(index);
        }
      });
    } else {
      final res = await MainRepository.deleteRoom(arguments.id!, rooms[index].id!);
      if(res.data['status'] == true) {
        if (index < rooms.length) {
          rooms.removeAt(index);
        }
      }
    }
  }

  static AddDormController get to => Get.find();
}
