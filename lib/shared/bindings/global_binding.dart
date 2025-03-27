import 'package:get/get.dart';
import 'package:kelola_kos/utils/services/auth_service.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync(() async => AuthService());
    Get.putAsync(() async => FirestoreService());
    Get.put(GlobalService());
  }
}
