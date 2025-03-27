import 'package:get/get.dart';
import 'package:kelola_kos/features/dorm_list/controllers/dorm_list_controller.dart';

class DormListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DormListController());
  }
}