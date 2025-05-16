import 'dart:developer';

import 'package:kelola_kos/features/detail_dorm/constants/detail_dorm_api_constant.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/http_service.dart';

class DetailDormRepository {
  DetailDormRepository._();
  static final httpClient = HttpService.dioCall();
  // static final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
  static const userId = 1;

  static Future<Dorm> getDorm(String id) async {
    log(id, name: 'Dorm id in detail dorm repo');
    log(GlobalService.to.dorms.toString());
    return GlobalService.to.dorms.where((dorm) => dorm.id == id).first;
  }

  static Future<List<Room>> getRoom(String dormId) async {
    log(GlobalService.to.rooms.toString(), name: 'Room in detail room repo');
    return GlobalService.to.rooms.where((room) => room.dormId == dormId).toList();
  }

  var apiConstant = DetailDormApiConstant();
}
