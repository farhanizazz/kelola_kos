import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/shared/models/user.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';
import 'package:workmanager/workmanager.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  Future<void> _handleAuthChanged(User? user) async {
    if (user == null) {
      Get.offAllNamed(Routes.loginRoute);
      GlobalService.unbindStreams();
      await LocalStorageService.deleteAuth();
      await Workmanager().cancelAll().then((value) {
        log('Workmanager Cancelled');
      });
    } else {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        final doc = await FirestoreService.to.getDocument('users', user.uid);

        if (doc != null && doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          final firestoreUser = FirestoreUser.fromMap(user.uid, data);

          await LocalStorageService.setAuth(firestoreUser);
          GlobalService.bindResidentStream();
          GlobalService.bindRoomStream();
          GlobalService.bindDormsStream();
        }

        Get.offAllNamed(Routes.navigationRoute);
        // GlobalService.refreshData();
      } catch (e, st) {
        log(e.toString(), name: "Error handleAuth");
        log(st.toString(), name: "Stacktrace");
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
