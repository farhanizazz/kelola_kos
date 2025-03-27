import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/user.dart';
import 'package:kelola_kos/shared/repositories/main_repository.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/http_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';

class DashboardController extends GetxController {
  final displayName = ''.obs;
  final RxList<Dorm> dorms = GlobalService.dorms;

  final httpClient = HttpService.dioCall();
  final FirestoreService firestoreService = FirestoreService();
  StreamSubscription? _userSubscription; // Make subscription nullable

  @override
  void onReady() {
    super.onReady();
    listenToDisplayName();
  }

  void listenToDisplayName() {
    final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
    if (userId == null) {
      log("User ID is null");
      return;
    }

    _userSubscription = firestoreService
        .streamCollection('users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final user = FirestoreUser.fromMap(snapshot.id, snapshot.data() as Map<String, dynamic>);
        displayName.value = user.name; // Automatically update name when Firestore changes
      } else {
        log('User document not found');
      }
    }, onError: (e) {
      log('Error listening to display name: ${e.toString()}');
    });
  }

  int get residentsTotal {
    return dorms.fold(0, (prev, dorm) => prev + dorm.residentCount);
  }

  Future<void> deleteDorm(String dormId) async {
    await MainRepository.deleteDorm(dormId);
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    super.onClose();
  }

  static DashboardController get to => Get.find();
}
