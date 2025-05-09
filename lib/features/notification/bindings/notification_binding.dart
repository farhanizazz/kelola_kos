import 'package:get/get.dart';
import 'package:kelola_kos/features/notification/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
  }
}