
import 'package:get/get.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/features/resident_list/repositories/resident_list_repository.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class ResidentListController extends GetxController {
  final RxList<Resident> residents = <Resident>[].obs;
  Rx<String> selectedCategory = 'all'.obs;

  Map<String, String> get statusFilter => {
    'all': 'Semua'.tr,
    'paid': 'Lunas'.tr,
    'unpaid': 'Belum Dibayar'.tr,
  };

  @override
  void onReady() {
    super.onReady();
    // Listen for changes to selectedCategory and filter residents accordingly
    ever<String>(selectedCategory, (_) => filterResidents());
    filterResidents(); // initial load
  }

  void filterResidents() {
    final all = GlobalService.to.residents;
    switch (selectedCategory.value) {
      case 'paid':
        residents.value = all.where((r) => r.paymentStatus == true).toList();
        break;
      case 'unpaid':
        residents.value = all.where((r) => r.paymentStatus == false).toList();
        break;
      default:
        residents.value = all;
    }
  }

  Future<void> deleteResident({
    required String dormId,
    required String residentId,
  }) async {
    await ResidentListRepository.deleteResident(dormId, residentId);
  }

  static ResidentListController get to => Get.find();
}

