import 'package:dio/dio.dart';
import 'package:kelola_kos/utils/services/http_service.dart';

class MainRepository {
  MainRepository._();
  static final httpClient = HttpService.dioCall();
  // static final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
  static const userId = 1;

  static Future<Response> deleteDorm(String dormId) async {
    return await httpClient.delete('/users/$userId/dorms/$dormId');
  }

  static Future<Response> deleteRoom(String dormId, String roomId) async {
    return await httpClient.delete('/users/$userId/dorms/$dormId/rooms/$roomId');
  }
}