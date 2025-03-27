import 'dart:developer';

import 'package:get/get.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/shared/models/room.dart';
import 'package:kelola_kos/utils/services/http_service.dart';

class GlobalService extends GetxService {
  static final RxList<Dorm> dorms = <Dorm>[].obs;
  static final RxList<Resident> residents = <Resident>[].obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    await fetchDorms();
    await fetchResidents();
    super.onInit();
  }

  static Future<void> fetchDorms() async {
    try {
      final data = await _MainRepository.getDorms();
      dorms.assignAll(data);
      log(dorms.toString());
    } catch (e, st) {
      log("Error fetching dorms: $e");
      log(st.toString(), name: 'Stacktrace');
    }
  }

  static Future<void> fetchResidents() async {
    try {
      final data = await _MainRepository.getResidents();
      residents.assignAll(data);
    } catch (e, st) {
      log("Error fetching residents: $e");
      log(st.toString(), name: 'Stacktrace');
    }
  }

  static Future<List<Room>> fetchRooms(String dormId) async {
    try {
      return await _MainRepository.getRooms(dormId);
    } catch (e) {
      log("Error fetching rooms: $e");
      rethrow;
    }
  }

  static void refreshData() {
    fetchDorms();
    fetchResidents();
  }
}

// Private repository inside MainService
class _MainRepository {
  _MainRepository._();

  static final httpClient = HttpService.dioCall();
  static const userId = 1;

  static Future<List<Dorm>> getDorms() async {
    final res = await httpClient.get('/users/$userId/dorms');
    return (res.data as List<dynamic>).map((dorm) => Dorm.fromMap(dorm)).toList();
  }

  static Future<List<Resident>> getResidents() async {
    final res = await httpClient.get('/users/$userId/resident');
    final List<dynamic> dorms = res.data;

    return dorms
        .map((resident) => Resident.fromMap(resident))
        .toList();
  }

  static Future<List<Room>> getRooms(String dormId) async {
    final res = await httpClient.get('/users/$userId/dorms/$dormId');
    final List<dynamic> rooms = res.data['rooms'];

    return rooms.map((room) => Room.fromMap(room)).toList();
  }
}