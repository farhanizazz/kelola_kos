import 'package:dio/dio.dart';
import 'package:kelola_kos/features/resident_list/constants/resident_list_api_constant.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/utils/services/http_service.dart';

class ResidentListRepository {
  ResidentListRepository._();
  static final httpClient = HttpService.dioCall();
  // static final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
  static const userId = 1;

  static Future<Response> deleteResident(String dormId, String residentId) async {
    return await httpClient.delete('/users/$userId/dorms/$dormId/resident/$residentId');
  }

  var apiConstant = ResidentListApiConstant();
}