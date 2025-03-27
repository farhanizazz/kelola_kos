import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/features/resident_list/repositories/resident_list_repository.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/repositories/main_repository.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class ResidentListController extends GetxController {
  final RxList<Resident> residents = GlobalService.residents;

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> deleteResident({
    required String dormId,
    required String residentId,
  }) async {
    await ResidentListRepository.deleteResident(dormId, residentId);
  }

  static ResidentListController get to => Get.find();
}
