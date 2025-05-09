import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/features/add_resident/repositories/add_resident_repository.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/shared/models/change_request.dart';
import 'package:kelola_kos/shared/models/request_status_enum.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/http_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';

class MainRepository {
  MainRepository._();

  static final httpClient = HttpService.dioCall();
  static final userId =
      LocalStorageService.box.get(LocalStorageConstant.USER_ID);

  // static const userId = 1;

  static Future<bool> deleteDorm(String dormId) async {
    safeCall(() async {
      FirestoreService firestore = FirestoreService.to;

      // Delete all rooms under the dorm first
      final roomsSnapshot = await FirebaseFirestore.instance
          .collection("Rooms")
          .where("dormId", isEqualTo: dormId)
          .get();
      // final residentsSnapshot = await FirebaseFirestore.instance
      //     .collection("Residents")
      //     .where("dormId", isEqualTo: dormId)
      //     .get();

      final dormDeleted = await firestore.deleteDocument("Dorms", dormId);

      if (dormDeleted) {
        for (var doc in roomsSnapshot.docs) {
          await firestore.forceDeleteDocument("Rooms", doc.id);
        }
        log("Dorm $dormId and associated rooms deleted successfully");
      }

      return true;
    });
    return false;
  }

  static Future<bool> deleteRoom(String roomId) async {
    safeCall(() async {
      FirestoreService firestore = FirestoreService.to;
      await firestore.deleteDocument("Rooms", roomId);
      log("Room deleted successfully");
      return true;
    });
    return false;
  }

  static Future<bool> deleteResident(String residentId) async {
    safeCall(() async {
      FirestoreService firestore = FirestoreService.to;
      await firestore.deleteDocument("Residents", residentId);
      log("Resident deleted successfully");
      return true;
    });
    return false;
  }

  static Future<void> updateRequestStatus(
      String requestId, RequestStatus newStatus) async {
    await safeCall(() async {
      FirestoreService firestore = FirestoreService.to;

      final ChangeRequest selectedChangeRequest = GlobalService
          .to.changeRequests
          .firstWhere((element) => element.id == requestId);

      final Resident selectedResident = GlobalService.to.residents
          .where(
              (resident) => resident.id == selectedChangeRequest.senderUserId)
          .first;

      // Step 1: Update the request status
      await firestore.updateDocument("Change Request", requestId, {
        "status": newStatus.value,
      });

      log(selectedChangeRequest.toString());

      // Step 2: If accepted, update relevant fields in the resident document
      if (newStatus == RequestStatus.accepted) {
        final changes = selectedChangeRequest.changes;

        // Construct a map of valid updates
        final Map<String, dynamic> updates = {};

        if (changes.phone.newValue.isNotEmpty &&
            changes.phone.newValue != changes.phone.old) {
          updates["phone"] = changes.phone.newValue;
        }

        if (changes.paymentDay.newValue.isNotEmpty &&
            changes.paymentDay.newValue != changes.paymentDay.old) {
          updates["paymentDay"] = int.tryParse(changes.paymentDay.newValue);
        }

        if (changes.paymentMonth.newValue.isNotEmpty &&
            changes.paymentMonth.newValue != changes.paymentMonth.old) {
          updates["paymentMonth"] = int.tryParse(changes.paymentMonth.newValue);
        }

        if (changes.recurrenceInterval.newValue.isNotEmpty &&
            changes.recurrenceInterval.newValue !=
                changes.recurrenceInterval.old) {
          updates["recurrenceInterval"] =
              int.tryParse(changes.recurrenceInterval.newValue);
        }

        log(updates.toString(), name: 'Update Request Status');

        if (updates.isNotEmpty) {
          if (changes.phone.newValue.isNotEmpty) {
            await AddResidentRepository.updateResident(
              dormId: selectedResident.dormId,
              roomId: selectedResident.roomId,
              residentId: selectedChangeRequest.senderUserId,
              newResident: Resident(
                ownerId: selectedResident.ownerId,
                id: selectedResident.id,
                name: selectedResident.name,
                roomId: selectedResident.roomId,
                dormId: selectedResident.dormId,
                paymentStatus: selectedResident.paymentStatus,
                paymentDay: updates['paymentDay'] ?? selectedResident.paymentDay,
                paymentMonth: updates['paymentMonth'] ?? selectedResident.paymentMonth,
                phone: updates['phone'] ?? selectedResident.phone,
                recurrenceInterval: updates['recurrenceInterval'] ?? selectedResident.recurrenceInterval,
              ),
            );
          } else {
            await firestore.updateDocument(
                "Residents", selectedChangeRequest.senderUserId, updates);
          }
        }
      }

      log("Request status updated successfully");
    });
  }
}
