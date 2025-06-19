import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/shared/models/user.dart';
import 'package:kelola_kos/utils/functions/show_confirmation_bottom_sheet.dart';
import 'package:kelola_kos/utils/services/firebase_messaging_service.dart';
import 'package:kelola_kos/utils/services/firebase_service.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';
import 'package:kelola_kos/utils/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  late final FirebaseAuth _auth;
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final firestoreClient = Get.find<FirestoreService>();
  final Rxn<Resident> resident = Rxn<Resident>();
  Rxn<User> firebaseUser = Rxn<User>();
  final RxInt authCount = 0.obs;
  Worker? _authWorker;
  StreamSubscription<User?>? _authSubscription;
  bool _isProcessingAuth = false;

  @override
  void onReady() {
    super.onReady();
    _auth = FirebaseAuth.instance;
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
        GlobalService.to.unbindStreams();
        Get.delete<GlobalService>();
        await LocalStorageService.deleteAuth();
        await Workmanager().cancelAll().then((value) {
          log('Workmanager Cancelled');
        });
        if (resident.value != null) {
          resident.value = null;
        }
        if(GlobalService.to.selectedResident.value != null) {
          log(GlobalService.to.selectedResident.value.toString(), name: "Selected Resident before");
          GlobalService.to.selectedResident.value = null;
          log(GlobalService.to.selectedResident.value.toString(), name: "Selected Resident after");
        }
        FirebaseMessagingService.to.disposeFCM();
        LocalStorageService.clearNotifications();
      } else {
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) return;

          // Check if the user authenticated via phone number
          log('Checking if phone auth...', name: 'AuthCheck');

          bool isPhoneAuth = user.providerData.any((info) => info.providerId == 'phone');
          log('isPhoneAuth evaluated to: $isPhoneAuth', name: 'AuthCheck');

          if (isPhoneAuth) {
            await GlobalService.to.bindResidentByPhoneNumberStream(user.phoneNumber!);
            log('User authenticated via phone number', name: 'Auth');
            final doc = await firestoreClient.getDocument(
                'Residents', user.phoneNumber!);
            resident.value =
                Resident.fromMap(doc?.data() as Map<String, dynamic>);
            await NotificationService().scheduleWithPermissionGuard(
              id: resident.value!.phone.codeUnits.reduce((a, b) => a + b) %
                  1000000,
              day: resident.value!.paymentDay,
              month: resident.value!.paymentMonth,
              residentName: resident.value!.name,
              notificationInterval: resident.value!.recurrenceInterval,
            );
            await Workmanager()
                .cancelByUniqueName("reschedule_notifications_id");
            await Workmanager().registerPeriodicTask(
              "reschedule_notifications_id",
              "rescheduleResidentNotificationsTask",
              frequency: const Duration(hours: 24),
              initialDelay: const Duration(minutes: 1),
              constraints: Constraints(
                networkType: NetworkType.not_required,
                requiresBatteryNotLow: false,
                requiresCharging: false,
                requiresDeviceIdle: false,
                requiresStorageNotLow: false,
              ),
            );
            log(resident.value.toString(), name: "Resident");
            FirebaseMessagingService.to.initFCM(userType: UserType.resident);
            Get.offAllNamed(Routes.residentDashboard,
                arguments: resident.value);
          } else {
            await Workmanager()
                .cancelByUniqueName("reschedule_notifications_id");
            await Workmanager().registerPeriodicTask(
              "reschedule_notifications_id",
              "rescheduleOwnerNotificationsTask",
              frequency: const Duration(hours: 24),
              initialDelay: const Duration(minutes: 1),
              constraints: Constraints(
                networkType: NetworkType.not_required,
                requiresBatteryNotLow: false,
                requiresCharging: false,
                requiresDeviceIdle: false,
                requiresStorageNotLow: false,
              ),
            );
            final doc =
                await FirestoreService.to.getDocument('users', user.uid);

            if (doc != null && doc.exists) {
              final data = doc.data() as Map<String, dynamic>;
              final firestoreUser = FirestoreUser.fromMap(user.uid, data);

              await LocalStorageService.setAuth(firestoreUser);
              GlobalService.to.bindResidentsStream();
              GlobalService.to.bindRoomStream();
              GlobalService.to.bindDormsStream();
              GlobalService.to.bindChangeRequestsStream();
            }
            FirebaseMessagingService.to.initFCM(userType: UserType.owner);

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
          try {
            await FirebaseMessagingService.to.clearFCMToken(
                userType: resident.value != null ? UserType.resident : UserType
                    .owner);
            log('FCM token cleared', name: "FCM Token");
          } catch(e, st) {
            log(e.toString(), name: "Error clearing FCM token");
            log(st.toString(), name: "Stacktrace");
          }
          await _auth.signOut();
        });
      },
    );
  }
}
