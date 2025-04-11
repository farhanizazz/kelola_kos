import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/http_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';

class MainRepository {
  MainRepository._();
  static final httpClient = HttpService.dioCall();
  static final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
  // static const userId = 1;

  static Future<bool> deleteDorm(String dormId) async {
    try {
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

      for (var doc in roomsSnapshot.docs) {
        await firestore.forceDeleteDocument("Rooms", doc.id);
      }

      // Delete the dorm itself
      await firestore.deleteDocument("Dorms", dormId);
      Get.back();
      log("Dorm $dormId and associated rooms deleted successfully");
      return true;
    } catch (e) {
      log("Error deleting dorm: $e");
      rethrow;
    }
  }

  static Future<bool> deleteRoom(String roomId) async {
    try {
      FirestoreService firestore = FirestoreService.to;
      await firestore.deleteDocument("Rooms", roomId);
      log("Room deleted successfully");
      return true;
    } catch (e) {
      log("Error deleting room: $e");
      return false;
    }
  }

  static Future<bool> deleteResident(String residentId) async {
    try {
      FirestoreService firestore = FirestoreService.to;
      await firestore.deleteDocument("Residents", residentId);
      log("Resident deleted successfully");
      return true;
    } catch (e) {
      log("Error deleting room: $e");
      return false;
    }
  }
}