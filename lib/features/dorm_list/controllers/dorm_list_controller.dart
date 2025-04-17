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

  Future<void> deleteDorm(String id) async {
    await MainRepository.deleteDorm(id);
    // GlobalService.refreshData();
    Get.back();
  }
  static DormListController get to => Get.find();
}
