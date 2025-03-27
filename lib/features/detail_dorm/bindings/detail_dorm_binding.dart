import 'package:get/get.dart';
import 'package:kelola_kos/features/detail_dorm/controllers/detail_dorm_controller.dart';

class DetailDormBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailDormController());
  }
}