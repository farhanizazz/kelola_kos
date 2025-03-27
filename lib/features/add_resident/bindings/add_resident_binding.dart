import 'package:get/get.dart';
import 'package:kelola_kos/features/add_resident/controllers/add_resident_controller.dart';

class AddResidentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddResidentController());
  }
}