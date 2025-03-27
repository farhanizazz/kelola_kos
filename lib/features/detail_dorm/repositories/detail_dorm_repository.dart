import 'dart:developer';

import 'package:kelola_kos/features/detail_dorm/constants/detail_dorm_api_constant.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/services/http_service.dart';

class DetailDormRepository {
  DetailDormRepository._();
  static final httpClient = HttpService.dioCall();
  // static final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
  static const userId = 1;

  static Future<Dorm> getDorm(String id) async {
    try {
      final res = await httpClient.get('/users/$userId/dorms/$id');
      return Dorm.fromMap(res.data);
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      rethrow;
    }
  }

  static Future<List<Room>> getRoom(String dormId) async {
    try {
      final res = await httpClient.get('/users/$userId/dorms/$dormId/rooms');

      // Ensure the response is a List before mapping
      if (res.data is List) {
        return (res.data as List)
            .map((room) => Room.fromMap(room as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Unexpected response format: ${res.data}");
      }
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      rethrow;
    }
  }

  var apiConstant = DetailDormApiConstant();
}
