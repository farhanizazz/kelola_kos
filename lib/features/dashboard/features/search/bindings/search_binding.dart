import 'package:get/get.dart';
import 'package:kelola_kos/features/dashboard/features/search/controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchController());
  }
}