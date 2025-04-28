import 'package:get/get.dart';
import 'package:kelola_kos/features/resident_dashboard/controllers/resident_dashboard_controller.dart';

class ResidentDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ResidentDashboardController());
  }
}