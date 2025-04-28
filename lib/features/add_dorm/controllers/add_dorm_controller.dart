import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/features/add_room/controllers/add_room_controller.dart';
import 'package:kelola_kos/features/add_room/views/ui/add_room_screen.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';
import 'package:kelola_kos/utils/services/supabase_service.dart';

class AddDormController extends GetxController {
  final TextEditingController dormNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rxn<File> dormImage = Rxn<File>();
  final RxList<Room> rooms = <Room>[].obs;
  late final Dorm arguments;
  final ImagePicker _picker = ImagePicker();
  final RxString imageUrl = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    _handleLostData();
    super.onInit();
    if (Get.arguments != null) {
      arguments = Get.arguments;
    }
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    if (Get.arguments != null) {
      dormNameController.text = arguments.name;
      locationController.text = arguments.location;
      imageUrlController.text = arguments.image ?? '';
      noteController.text = arguments.note ?? '';
      rooms.assignAll(
          GlobalService.rooms.where((room) => room.dormId == arguments.id));
      try {
        final supabaseImageUrl = await SupabaseService.getImage(arguments.image ?? '');
        log(supabaseImageUrl, name: 'Supabase Image');
        imageUrl.value = supabaseImageUrl;
      } catch (e, st) {
        log(arguments.image ?? '');
        log(e.toString(), name: 'Supabase Image');
        log(st.toString(), name: 'Supabase Image');
      }
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: AddRoomScreen(),
      ),
      isScrollControlled: true,
    );
    log(result.toString(), name: "Result: ");
    if (result == true) {
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
    const urlPattern =
        r'^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:\d+)?(\/.*\.(png|jpg|jpeg|gif|bmp|webp))$';
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
      if (dormImage.value == null) {
        Get.snackbar(
          'Gambar tidak boleh kosong!',
          'Tolong masukkan gambar kos.',
          backgroundColor: Get.theme.colorScheme.errorContainer,
        );
        return;
      }
      try {
        FirestoreService firestore = FirestoreService.to;
        WriteBatch batch = FirebaseFirestore.instance.batch();
        String clean(String text) => text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
        final tokens = {
          ...clean(dormNameController.text).split(' '),
          ...clean(locationController.text).split(' '),
          ...clean(noteController.text).split(' '),
        }.where((token) => token.isNotEmpty).toList();
        if (Get.arguments != null) {
          final dormData = {
            'userId': LocalStorageService.box.get(LocalStorageConstant.USER_ID),
            'name': dormNameController.text,
            'location': locationController.text,
            'note': noteController.text,
            'image': arguments.image,
            'search_token': tokens
          };
          log("Update", name: "Add Dorm Status");
          final dormId = arguments.id!;
          await firestore.updateDocument("Dorms", dormId, dormData);
        } else {
          final String imagePath = await SupabaseService.uploadImage(dormImage.value!);
          final dormData = {
            'userId': LocalStorageService.box.get(LocalStorageConstant.USER_ID),
            'name': dormNameController.text,
            'location': locationController.text,
            'note': noteController.text,
            'image': imagePath,
            'search_token': tokens,
          };
          final newDocRef =
              FirebaseFirestore.instance.collection("Dorms").doc();
          await firestore.setDocument("Dorms", newDocRef.id, dormData);

          // Add rooms in batch with a reference to the dormId
          for (var room in rooms) {
            final roomDocRef =
                FirebaseFirestore.instance.collection("Rooms").doc();
            final roomData = room.toMap(
                userId:
                    LocalStorageService.box.get(LocalStorageConstant.USER_ID));
            roomData['dormId'] = newDocRef.id;
            batch.set(roomDocRef,
                {...roomData, 'createdAt': FieldValue.serverTimestamp()});
          }

          await batch.commit();
        }

        if (Get.isBottomSheetOpen != true) {
          Get.back();
        }
      } catch (e, st) {
        log(e.toString());
      }
    }
  }

  Future<void> pickImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        dormImage.value = File(picked.path);
      }
    } catch (e, st) {
      log('Image pick error: $e', name: 'ImagePicker');
      log('StackTrace: $st', name: 'ImagePicker');
    }
  }

  Future<void> _handleLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) return;

    if (response.files != null && response.files!.isNotEmpty) {
      dormImage.value = File(response.files!.first.path);
    } else if (response.file != null) {
      dormImage.value = File(response.file!.path);
    } else {
      debugPrint('Error retrieving lost image: ${response.exception}');
    }
  }

  Future<void> deleteRoom(int index) async {
    if (index < 0 || index >= rooms.length) return;

    Future.delayed(300.ms, () {
      if (index < rooms.length) {
        rooms.removeAt(index);
      }
    });
  }

  static AddDormController get to => Get.find();
}
