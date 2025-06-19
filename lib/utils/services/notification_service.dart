import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/shared/models/request_status_enum.dart';
import 'package:kelola_kos/shared/models/scheduled_notification.dart';
import 'package:kelola_kos/shared/repositories/main_repository.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends GetxService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  static NotificationService get to => Get.find<NotificationService>();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init({bool requestPermission = true}) async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload ?? '';
        switch (response.actionId) {
          case 'ACCEPT_ACTION':
            MainRepository.updateRequestStatus(payload, RequestStatus.accepted);
            log("User accepted the request.");
            break;
          case 'DECLINE_ACTION':
            MainRepository.updateRequestStatus(payload, RequestStatus.declined);
            log("User declined the request.");
            break;
          default:
            break;
        }
      },
    );

    if (requestPermission) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<bool> hasExactAlarmPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    return await androidPlugin?.canScheduleExactNotifications() ?? false;
  }

  Future<void> requestExactAlarmPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  Future<void> scheduleWithPermissionGuard({
    required int id,
    required int day,
    required int month,
    required String residentName,
    required Duration notificationInterval,
  }) async {
    final hasPermission = await hasExactAlarmPermission();

    if (!hasPermission) {
      log('No exact alarm permission. Requesting...');
      await requestExactAlarmPermission();
    }

    try {
      await schedulePaymentReminder(
        id: id,
        day: day,
        month: month,
        residentName: residentName,
        notificationInterval: notificationInterval,
      );
    } catch (e, st) {
      log('Failed to schedule notification: $e');
      log('Stacktrace: $st');
    }
  }

  Future<void> schedulePaymentReminder({
    required int id,
    required int day,
    required int month,
    required String residentName,
    required Duration notificationInterval,
  }) async {
    DateTime now = DateTime.now();
    DateTime targetDate = DateTime(now.year, month, day, 15, 40);

    if (targetDate.isBefore(now)) {
      targetDate = DateTime(now.year + 1, month, day, 14, 40);
    }

    await _plugin
        .zonedSchedule(
      id,
      'Waktunya Pembayaran',
      'Penghuni $residentName sudah waktunya bayar kos.',
      tz.TZDateTime.from(targetDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'payment_channel',
          'Payment Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    )
        .then((value) {
      LocalStorageService.saveScheduledNotification(
        ScheduledNotification(
            id: id,
            residentName: residentName,
            scheduledTime: targetDate,
            recurrenceInterval: notificationInterval),
      );
      log("Notification scheduled for $residentName",
          name: "NotificationService");
    }).onError((e, st) {
      log(e.toString());
      log(st.toString());
    });
  }

  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
    log("Notification canceled for id: $id", name: "NotificationService");
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    log("All notifications canceled", name: "NotificationService");
  }

  Future<void> checkAndRescheduleNotifications() async {
    final notifications =
        await LocalStorageService.getAllScheduledNotifications();
    log("Notification Schedule initialized!", name: "Notification Schedule");

    for (final notif in notifications) {
      if (notif.scheduledTime.isBefore(DateTime.now())) {
        final newTime = notif.scheduledTime.add(notif.recurrenceInterval);
        await NotificationService().schedulePaymentReminder(
            id: notif.id,
            residentName: notif.residentName,
            day: newTime.day,
            month: newTime.month,
            notificationInterval: notif.recurrenceInterval);
        await LocalStorageService.updateScheduledNotification(
            notif.id, newTime);
      }
    }
    log("Notification Schedule initialized successfully!",
        name: "Notification Schedule");
  }

  Future<void> showLocalFirebaseNotification(RemoteMessage message) async {
    final isResponse = message.data['type'] == 'change_request_response' ? true : false;
    AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
            'firebase_messaging_id', 'Firebase Messaging',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            actions: isResponse ? null : [
          const AndroidNotificationAction(
            'ACCEPT_ACTION',
            'Terima',
            showsUserInterface: true,
            cancelNotification: true,
          ),
          const AndroidNotificationAction(
            'DECLINE_ACTION',
            'Tolak',
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ]);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _plugin.show(
      message.notification.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No body',
      notificationDetails,
      payload: message.data['notificationId'],
    );
  }
}
