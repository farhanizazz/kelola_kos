import 'package:dio/dio.dart';
import 'package:kelola_kos/features/add_resident/constants/add_resident_api_constant.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/utils/services/http_service.dart';

class AddResidentRepository {
  AddResidentRepository._();

  static final httpClient = HttpService.dioCall();

  // static final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
  static const userId = 1;

  static Future<Response> addResident(
      String dormId, String roomId, Resident resident) async {
    return await httpClient.post(
        '/users/$userId/dorms/$dormId/rooms/$roomId/resident',
        data: resident.toMap());
  }

  static Future<Response> updateResident({
    required String dormId,
    required String roomId,
    required String residentId,
    required Resident resident,
  }) async {
    return await httpClient.put(
        '/users/$userId/dorms/$dormId/rooms/$roomId/resident/$residentId',
        data: resident.toMap());
  }

  var apiConstant = AddResidentApiConstant();
}
