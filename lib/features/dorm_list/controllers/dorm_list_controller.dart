import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/repositories/main_repository.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class DormListController extends GetxController {
  final RxList<Dorm> dorms = GlobalService.dorms;

  @override
  void onReady() {
    super.onReady();
  }

  void deleteDorm(String id) {
    Get.dialog(
      AlertDialog(
        title: Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus item ini?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Batal", style: TextStyle(
              color: Get.theme.colorScheme.onSurface
            ),),
          ),
          TextButton(
            onPressed: () async {
              await MainRepository.deleteDorm(id);
              // GlobalService.refreshData();
              Get.back();
            },
            child: Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  static DormListController get to => Get.find();
}
