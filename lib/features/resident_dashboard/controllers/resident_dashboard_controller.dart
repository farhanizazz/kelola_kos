import 'package:get/get.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';

class ResidentDashboardController extends GetxController {
  final Resident resident = Get.arguments;

  static ResidentDashboardController get to => Get.find();
}
