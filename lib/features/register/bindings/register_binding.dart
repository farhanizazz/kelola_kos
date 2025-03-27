import 'package:get/get.dart';
import 'package:kelola_kos/features/register/controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController());
  }
}