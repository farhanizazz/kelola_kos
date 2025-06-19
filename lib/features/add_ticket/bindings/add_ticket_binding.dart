import 'package:get/get.dart';
import 'package:kelola_kos/features/add_ticket/controllers/add_ticket_controller.dart';

class AddTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddTicketController());
  }
}