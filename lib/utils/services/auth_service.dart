import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/shared/models/user.dart';
import 'package:kelola_kos/utils/functions/show_confirmation_bottom_sheet.dart';
import 'package:kelola_kos/utils/services/firebase_service.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';
import 'package:workmanager/workmanager.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService firebaseService = FirebaseService();
  final firestoreClient = FirestoreService();
  final Rxn<Resident> resident = Rxn<Resident>();
  Rxn<User> firebaseUser = Rxn<User>();
  final RxInt authCount = 0.obs;
  Worker? _authWorker;
  StreamSubscription<User?>? _authSubscription;
  bool _isProcessingAuth = false;

  @override
  void onReady() {
    super.onReady();
    _initAuthStream();
  }

  void _initAuthStream() {
    firebaseUser.bindStream(_auth.authStateChanges());
    _authWorker?.dispose();
    _authWorker = ever(firebaseUser, _handleAuthChanged);
  }

  Future<void> _handleAuthChanged(User? user) async {
    if (_isProcessingAuth) return;
    _isProcessingAuth = true;

    try {
      if (user == null) {
        Get.offAllNamed(Routes.loginRoute);
        GlobalService.unbindStreams();
        await LocalStorageService.deleteAuth();
        await Workmanager().cancelAll().then((value) {
          log('Workmanager Cancelled');
        });
        if (resident.value != null) {
          resident.value = null;
        }
      } else {
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) return;

          // Check if the user authenticated via phone number
          bool isPhoneAuth = user.providerData.any((info) =>
          info.providerId == 'phone');

          if (isPhoneAuth) {
            final doc = await firestoreClient.getDocument('Residents', user.phoneNumber!);
            resident.value = Resident.fromMap(doc?.data() as Map<String, dynamic>);
            Get.offAllNamed(Routes.residentDashboard, arguments: resident.value);
          } else {
            final doc = await FirestoreService.to.getDocument('users', user.uid);

            if (doc != null && doc.exists) {
              final data = doc.data() as Map<String, dynamic>;
              final firestoreUser = FirestoreUser.fromMap(user.uid, data);

              await LocalStorageService.setAuth(firestoreUser);
              GlobalService.bindResidentStream();
              GlobalService.bindRoomStream();
              GlobalService.bindDormsStream();
            }

            if (!Get.currentRoute.endsWith(Routes.navigationRoute)) {
              Get.offAllNamed(Routes.navigationRoute);
            }
          }
          authCount.value++;
          log(authCount.value.toString(), name: "Auth Count");
        } catch (e, st) {
          log(e.toString(), name: "Error handleAuth");
          log(st.toString(), name: "Stacktrace");
        }
      }
    } finally {
      // Reset the processing flag
      _isProcessingAuth = false;
    }
  }

  @override
  void onClose() {
    // Properly dispose of resources
    _authWorker?.dispose();
    _authSubscription?.cancel();
    super.onClose();
  }

  Future<void> signOut() async {
    showConfirmationBottomSheet(
      title: 'Apakah kamu yakin?',
      message: 'Apakah kamu yakin mau logout?.',
      onConfirm: () async {
        firebaseService.execute(() async {
          await _auth.signOut();
        });
      },
    );
  }
}