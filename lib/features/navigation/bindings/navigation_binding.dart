import 'package:get/get.dart';
import 'package:kelola_kos/features/navigation/controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
  }
}