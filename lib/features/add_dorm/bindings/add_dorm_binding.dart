import 'package:get/get.dart';
import 'package:kelola_kos/features/add_dorm/controllers/add_dorm_controller.dart';

class AddDormBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddDormController());
  }
}