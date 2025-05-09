import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/features/add_resident/constants/add_resident_api_constant.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/utils/functions/normalize_phone_number.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/http_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';

class AddResidentRepository {
  AddResidentRepository._();

  static final httpClient = HttpService.dioCall();
  static final FirestoreService firestoreClient = FirestoreService.to;

  static final userId =
      LocalStorageService.box.get(LocalStorageConstant.USER_ID);

  // static const userId = 1;

  static Future<void> addResident(
      String dormId, String roomId, Resident resident) async {
    safeCall(() async {
      final newDocRef =
          FirebaseFirestore.instance.collection("Residents").doc();
      log(newDocRef.path);
      await firestoreClient.setDocumentIfNotExists('Residents',
          normalizePhoneNumber(resident.phone), resident.toMap(userId: userId));
    });
  }

  static Future<void> updateResident({
    required String dormId,
    required String roomId,
    required String residentId,
    required Resident newResident,
  }) async {
    await firestoreClient.deleteDocument('Residents', residentId, showConfirmation: false);
    await addResident(dormId, roomId, newResident);
  }

  static Future<void> requestUpdateResident({
    required String dormId,
    required String roomId,
    required String residentId,
    required Resident oldResidentData,
    required Resident newResidentData,
  }) async {
    final timestamp = DateTime.now();

    final changes = <String, Map<String, String>>{};

    // Helper to compare and add only changed fields
    void addIfChanged(String field, dynamic oldVal, dynamic newVal) {
      if (oldVal != newVal) {
        changes[field] = {
          'old': oldVal.toString(),
          'new': newVal.toString(),
        };
      }
    }

    addIfChanged('phone', oldResidentData.phone, newResidentData.phone);
    addIfChanged('paymentDay', oldResidentData.paymentDay, newResidentData.paymentDay);
    addIfChanged('paymentMonth', oldResidentData.paymentMonth, newResidentData.paymentMonth);
    addIfChanged('recurrenceInterval',
        oldResidentData.recurrenceInterval.inMilliseconds,
        newResidentData.recurrenceInterval.inMilliseconds);

    final residentName = newResidentData.name;

    await firestoreClient.setDocument('Change Request', null, {
      'title': 'Request perubahan oleh $residentName',
      'body': '$residentName ingin mengubah profile miliknya',
      'receiverUserId': oldResidentData.ownerId,
      'senderUserId': oldResidentData.id,
      'status': 'pending',
      'createdAt': timestamp,
      'changes': {
        ...changes
      },
    });
  }


  static final List<String> days = List.generate(31, (index) => '${index + 1}');
  static final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  var apiConstant = AddResidentApiConstant();
}
