import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/features/add_room/constants/add_room_api_constant.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/services/http_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';

class AddRoomRepository {
  AddRoomRepository._();

  static final httpClient = HttpService.dioCall();

  // static final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
  static const userId = 1;

  static Future<Response> addRoom({
    required int dormId,
    required List<Room> rooms,
  }) async {
    if (rooms.length == 1) {
      final res = await httpClient.post('/users/$userId/dorms/$dormId/rooms',
          data: rooms[0].toMap());
      return res;
    } else {
      final res = await httpClient.post(
        '/users/$userId/dorms/$dormId/rooms',
        data: rooms.map((room) {
          final newRoom = room.copyWith(dormId: dormId.toString());
          return newRoom.toMap();
        }).toList(),
      );
      return res;
    }
  }

  static Future<Response> updateRoom({
    required String dormId,
    required Room room,
  }) async {
    final res = await httpClient.put('/users/$userId/dorms/$dormId/rooms/${room.id}',
        data: room.toMap());
    return res;
  }

  var apiConstant = AddRoomApiConstant();
}
