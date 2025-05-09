import 'package:get/get.dart';
import 'package:kelola_kos/utils/services/auth_service.dart';
import 'package:kelola_kos/utils/services/firebase_messaging_service.dart';
import 'package:kelola_kos/utils/services/firebase_service.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/notification_service.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirestoreService());
    Get.put(FirebaseService());
    Get.put(GlobalService());
    Get.putAsync(() async => AuthService());
    Get.put(NotificationService());
    Get.put(FirebaseMessagingService());
  }
}
