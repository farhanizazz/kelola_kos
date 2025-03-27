import 'package:get/get.dart';
import 'package:kelola_kos/features/add_room/controllers/add_room_controller.dart';

class AddRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddRoomController());
  }
}