import 'package:get/get.dart';
import 'package:kelola_kos/features/login_penghuni/controllers/login_penghuni_controller.dart';

class LoginPenghuniBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginPenghuniController());
  }
}