import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/features/add_room/constants/add_room_api_constant.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/http_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';

class AddRoomRepository {
  AddRoomRepository._();

  static final httpClient = HttpService.dioCall();
  static final FirestoreService firestoreClient = FirestoreService.to;


  static final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
  // static const userId = 1;

  static Future<void> addRoom({
    required String dormId,
    required List<Room> rooms,
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    final roomsCollection = firestoreClient.collection("Rooms");

    for (var room in rooms) {
      final docRef = roomsCollection.doc();
      final roomData = room.copyWith(dormId: dormId.toString()).toMap(userId: userId);
      batch.set(docRef, {...roomData, 'createdAt': FieldValue.serverTimestamp()});
    }

    await batch.commit();
  }

  static Future<void> updateRoom({
    required String dormId,
    required Room room,
  }) async {
    safeCall(() async {
      final roomRef = FirebaseFirestore.instance.collection('Rooms').doc(room.id);
      await firestoreClient.updateDocument('Rooms', roomRef.id,room.toMap());
    });
  }

  var apiConstant = AddRoomApiConstant();
}
