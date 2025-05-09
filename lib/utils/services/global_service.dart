import 'dart:developer';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/shared/models/change_request.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/http_service.dart';
import 'package:kelola_kos/utils/services/notification_service.dart';

import 'local_storage_service.dart';

class GlobalService extends GetxService {
  static GlobalService get to => Get.find<GlobalService>();

  RxList<Dorm> dorms = <Dorm>[].obs;
  RxList<Resident> residents = <Resident>[].obs;
  RxList<Room> rooms = <Room>[].obs;
  RxList<ChangeRequest> changeRequests = <ChangeRequest>[].obs;
  /// Holds the currently logged-in resident, identified by their phone number.
  ///
  /// This value is populated after a successful login via phone number authentication. Refer to auth_service.dart to see the binding
  Rxn<Resident> selectedResident = Rxn<Resident>();

  final FirestoreService firestoreClient = FirestoreService();

  @override
  void onInit() async {
    // TODO: implement onInit
    ever(dorms, (value) {
      log(value.toString(), name: 'GlobalService Dorms');
    });
    ever(residents, (value) {
      log(residents.toString(), name: 'GlobalService Resident');
    });
    ever(rooms, (value) {
      log(rooms.toString(), name: 'GlobalService Room');
    });
    ever(changeRequests, (value) {
      log(changeRequests.toString(), name: 'GlobalService ChangeRequest');
    });
    super.onInit();
  }

  void bindDormsStream() {
    log('Binding dorms with userId: $userId', name: 'DormStream');
    dorms.bindStream(
      firestoreClient
          .collection('Dorms')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Dorm.fromMap(
              {...data, 'id': doc.id}); // ensure `id` is included if needed
        }).toList();
      }),
    );
  }

  void bindChangeRequestsStream() {
    log('Binding change request with userId: $userId', name: 'ChangeRequestStream');
    changeRequests.bindStream(
      firestoreClient
          .collection('Change Request')
          .where('receiverUserId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          log(data.toString(), name: 'ChangeRequestStream');
          try {
            return ChangeRequest.fromMap(
                {...data, 'id': doc.id});
          } catch (e) {
            log('Error parsing change request: $e', name: 'ChangeRequestStream');
            rethrow;
          }
        }).toList();
      }),
    );
  }

  void bindRoomStream() {
    try {
      log('Binding rooms with userId: $userId', name: 'RoomStream');
      rooms.bindStream(
        firestoreClient
            .collection('Rooms')
            .orderBy('roomName', descending: false)
            .where('userId', isEqualTo: userId)
            .snapshots()
            .handleError((error) => log('Stream error: $error'))
            .map((QuerySnapshot snapshot) {
          return snapshot.docs
              .map((doc) {
                try {
                  final data = doc.data() as Map<String, dynamic>;
                  final newRoom = Room.fromMap({...data, 'id': doc.id});
                  return newRoom;
                } catch (e, st) {
                  log('Room parsing failed: $e');
                  log('Stacktrace: $st');
                }
              })
              .whereType<Room>()
              .toList();
        }),
      );
    } catch (e, st) {
      log('Error binding room, Error: $e');
      log('Stacktrace: $st');
    }
  }

  void bindResidentsStream() {
    try {
      log('Binding resident with userId: $userId', name: 'ResidentStream');
      residents.bindStream(
        firestoreClient
            .collection('Residents')
            .where('userId', isEqualTo: userId)
            .snapshots()
            .handleError((error) => log('Stream error: $error'))
            .map((QuerySnapshot snapshot) {
          final residents = snapshot.docs
              .map((doc) {
                try {
                  final data = doc.data() as Map<String, dynamic>;
                  return Resident.fromMap({...data, 'id': doc.id});
                } catch (e, st) {
                  log('Room parsing failed: $e');
                  log('Stacktrace: $st');
                }
              })
              .whereType<Resident>()
              .toList();

          for (final r in residents) {
            final id = r.id.hashCode;
            NotificationService().cancel(id);
            NotificationService().scheduleWithPermissionGuard(
              id: id,
              day: r.paymentDay,
              month: r.paymentMonth,
              residentName: r.name,
              notificationInterval: r.recurrenceInterval,
            );
          }

          return residents;
        }),
      );
    } catch (e, st) {
      log('Error binding room, Error: $e');
      log('Stacktrace: $st');
    }
  }

  void bindResidentByPhoneNumberStream(String phoneNumber) {
    safeCall(() async {
      selectedResident.bindStream(firestoreClient
          .collection('Residents')
          .doc(phoneNumber)
          .snapshots()
          .map((DocumentSnapshot snapshot) {
            final data = snapshot.data() as Map<String, dynamic>;
        final Resident resident =
            Resident.fromMap(snapshot.data() as Map<String, dynamic>);
        return resident;
      }));
    });
  }

  void unbindStreams() {
    try {
      dorms.close();
      rooms.close();
      residents.close();

      dorms = <Dorm>[].obs;
      rooms = <Room>[].obs;
      residents = <Resident>[].obs;

      log('Streams unbound and data cleared.', name: 'GlobalService');
    } catch (e, st) {
      log('Failed to unbind streams: $e', name: 'GlobalService');
      log(st.toString());
    }
  }

  static String? get userId =>
      LocalStorageService.box.get(LocalStorageConstant.USER_ID);
}

// Private repository inside MainService
class _MainRepository {
  _MainRepository._();

  static final httpClient = HttpService.dioCall();
  static const userId = 1;

  static Future<List<Dorm>> getDorms() async {
    final res = await httpClient.get('/users/$userId/dorms');
    return (res.data as List<dynamic>)
        .map((dorm) => Dorm.fromMap(dorm))
        .toList();
  }

  static Future<List<Resident>> getResidents() async {
    final res = await httpClient.get('/users/$userId/resident');
    final List<dynamic> dorms = res.data;

    return dorms.map((resident) => Resident.fromMap(resident)).toList();
  }

  static Future<List<Room>> getRooms(String dormId) async {
    final res = await httpClient.get('/users/$userId/dorms/$dormId');
    final List<dynamic> rooms = res.data['rooms'];

    return rooms.map((room) => Room.fromMap(room)).toList();
  }
}

Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid) {
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );
    await intent.launch();
  }
}
