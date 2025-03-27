import 'package:get/get.dart';
import 'package:kelola_kos/features/resident_list/controllers/resident_list_controller.dart';

class ResidentListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResidentListController());
  }
}