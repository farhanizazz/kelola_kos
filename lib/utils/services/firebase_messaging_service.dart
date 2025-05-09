import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/utils/functions/safe_call.dart';
import 'package:kelola_kos/utils/services/auth_service.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

import 'notification_service.dart';

enum UserType {
  owner,
  resident,
}

class FirebaseMessagingService extends GetxService {
  static FirebaseMessagingService get to =>
      Get.find<FirebaseMessagingService>();

  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirestoreService firestoreClient = FirestoreService.to;
  late final StreamSubscription<RemoteMessage> streamSubscription;
  String? token;

  Future<void> initFCM({
    required UserType userType,
  }) async {
    await _requestNotificationPermissions();
    await _getToken(userType: userType);
    _listenToMessages();
    log('FCM initialized, user is ${userType == UserType.resident ? 'resident' : 'owner'}',
        name: 'FCM');
  }

  Future<void> _requestNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    log('Notification permission status: ${settings.authorizationStatus}',
        name: 'Notification Permission');
  }

  Future<void> _getToken({
    required UserType userType,
  }) async {
    token = await messaging.getToken();
    if (token == null) return;

    log('FCM Token: $token', name: 'FCM Token');

    late final DocumentReference<Map<String, dynamic>> docRef;
    if (userType == UserType.resident) {
      docRef = firestoreClient.collection('Residents').doc(
            GlobalService.to.selectedResident.value!.id,
          );
    } else if (userType == UserType.owner) {
      docRef = firestoreClient
          .collection('users')
          .doc(AuthService.to.firebaseUser.value!.uid);
    }

    final docSnap = await docRef.get();

    List<dynamic> existingTokens = [];
    if (docSnap.exists) {
      final data = docSnap.data();
      existingTokens = (data?['fcmTokens'] ?? []) as List<dynamic>;
      if (!existingTokens.contains(token)) {
        existingTokens.add(token);
        await docRef.update({'fcmTokens': existingTokens});
      }
    } else {
      await docRef.set({
        'fcmTokens': [token]
      });
    }

    messaging.onTokenRefresh.listen((newToken) async {
      log('New FCM Token: $newToken', name: 'New FCM Token');

      final latestSnap = await docRef.get();
      if (!latestSnap.exists) return;

      final data = latestSnap.data();
      final List<dynamic> currentTokens =
          (data?['fcmTokens'] ?? []) as List<dynamic>;

      final updatedTokens = currentTokens.where((t) => t != token).toList()
        ..add(newToken);

      token = newToken;
      await docRef.update({'fcmTokens': updatedTokens});
    });
  }

  void _listenToMessages() {
    streamSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notificationId = message.data['notificationId'];
      log('Received foreground message: ${message.notification?.title}',
          name: 'Foreground Message');

      safeCall(() async {
        NotificationService.to.showLocalFirebaseNotification(message);
      });
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void disposeFCM() {
    token = null;
    streamSubscription.cancel();
    // optionally remove listeners, reset state
    log('FCM disposed', name: 'FCM');
  }

  Future<void> clearFCMToken({
    required UserType userType,
  }) async {
    if (token == null) return;

    late final DocumentReference<Map<String, dynamic>> docRef;
    if (userType == UserType.resident) {
      docRef = firestoreClient.collection('Residents').doc(
            GlobalService.to.selectedResident.value!.id,
          );
    } else if (userType == UserType.owner) {
      docRef = firestoreClient
          .collection('users')
          .doc(AuthService.to.firebaseUser.value!.uid);
    }

    final docSnap = await docRef.get();
    if (docSnap.exists) {
      final data = docSnap.data();
      final List<dynamic> tokens = (data?['fcmTokens'] ?? []) as List<dynamic>;
      if (tokens.contains(token)) {
        tokens.remove(token);
        await docRef.update({'fcmTokens': tokens});
        log('FCM token removed from Firestore', name: 'FCM Token');
      }
    }

    await messaging.deleteToken();
    log('FCM token deleted from FirebaseMessaging', name: 'FCM Token');
    token = null;
  }
}

// MUST be a top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationService.to.showLocalFirebaseNotification(message);
  log('Handling a background message: ${message.messageId}',
      name: 'Background Message');
}
