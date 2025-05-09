import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/shared/models/scheduled_notification.dart';
import 'package:kelola_kos/shared/models/user.dart';

class LocalStorageService extends GetxService {
  LocalStorageService._();

  static final box = Hive.box("venturo");

  /// Kode untuk setting localstorage sesuai dengan repository
  static Future<void> setAuth(
      FirestoreUser userData) async {
    await box.put(LocalStorageConstant.USER_ID, userData.uid);
    await box.put(LocalStorageConstant.NAME, userData.name);
    await box.put(LocalStorageConstant.FULLNAME, userData.fullName);
    await box.put(LocalStorageConstant.PHONE, userData.phoneNumber);
    await box.put(LocalStorageConstant.EMAIL, userData.email);
    log("success", name: "SetAuth status");
  }

  static Future deleteAuth() async {
    box.clear();
    log("success", name: "deleteAuth status");
  }
  static Future<void> clearNotifications() async {
    final box = Hive.box('notification');
    await box.clear();
    log('Notifications cleared');
  }

  static Future<void> saveScheduledNotification(ScheduledNotification notification) async {
    final box = Hive.box('notification');

    await box.put(notification.id, {
      'id': notification.id,
      'residentName': notification.residentName,
      'recurrenceInterval': notification.recurrenceInterval.inMilliseconds,
      'scheduledTime': notification.scheduledTime.toIso8601String(),
    });
  }

  static Future<ScheduledNotification?> getScheduledNotification(int id) async {
    final box = Hive.box('notification');
    final data = box.get(id);

    if (data == null) return null;

    return ScheduledNotification(
      id: data['id'],
      residentName: data['residentName'],
      recurrenceInterval: Duration(milliseconds: data['recurrenceInterval']),
      scheduledTime: DateTime.parse(data['scheduledTime']),
    );
  }

  static Future<void> updateScheduledNotification(int id, DateTime newTime) async {
    final box = Hive.box('notification');
    final existing = box.get(id);

    if (existing == null) return;

    final updated = Map<String, dynamic>.from(existing);
    updated['scheduledTime'] = newTime.toIso8601String();

    await box.put(id, updated);
  }


  static Future<List<ScheduledNotification>> getAllScheduledNotifications() async {
    final box = Hive.box('notification');

    final notifications = <ScheduledNotification>[];

    for (var entry in box.values) {
      try {
        final data = Map<String, dynamic>.from(entry);
        final notification = ScheduledNotification(
          id: data['id'],
          residentName: data['residentName'],
          recurrenceInterval: Duration(milliseconds: data['recurrenceInterval']),
          scheduledTime: DateTime.parse(data['scheduledTime']),
        );
        notifications.add(notification);
      } catch (e, st) {
        log(e.toString(), name: 'Data Error| LocalStorageService.dart');
        log(st.toString());
        continue;
      }
    }

    return notifications;
  }
}
