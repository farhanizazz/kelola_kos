import 'dart:developer';

import 'package:kelola_kos/features/detail_dorm/constants/detail_dorm_api_constant.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/http_service.dart';

class DetailDormRepository {
  DetailDormRepository._();
  static final httpClient = HttpService.dioCall();
  // static final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
  static const userId = 1;

  static Future<Dorm> getDorm(String id) async {
    try {
      return GlobalService.dorms.where((dorm) => dorm.id == id).first;
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      rethrow;
    }
  }

  static Future<List<Room>> getRoom(String dormId) async {
    try {
      log(GlobalService.rooms.toString(), name: 'Room in detail room repo');
      return GlobalService.rooms.where((room) => room.dormId == dormId).toList();
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      rethrow;
    }
  }

  var apiConstant = DetailDormApiConstant();
}
