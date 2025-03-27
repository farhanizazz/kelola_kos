import 'package:dio/dio.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/features/add_dorm/constants/add_dorm_api_constant.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/utils/services/http_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';

class AddDormRepository {
  AddDormRepository._();
  static final httpClient = HttpService.dioCall();
  // static final userId = LocalStorageService.box.get(LocalStorageConstant.USER_ID);
  static const userId = 1;

  static Future<Response> addDorm(Object? data) async {
    return await httpClient.post('/users/$userId/dorms', data: data);
  }

  static Future<Response> updateDorm({
    Object? data,
    required String dormId,
  }) async {
    return await httpClient.put('/users/$userId/dorms/$dormId', data: data);
  }


  var apiConstant = AddDormApiConstant();
}