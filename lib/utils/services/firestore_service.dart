import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/shared/widgets/loading_bar.dart';
import 'dart:developer';
import 'package:kelola_kos/utils/functions/show_error_bottom_sheet.dart';

class FirestoreService extends GetxService {
  static FirestoreService get to => Get.find<FirestoreService>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Called when the service is initialized
  @override
  void onInit() {
    log('[FirestoreService] Initialized');
    super.onInit();
  }

  /// Logs Firestore actions
  void _log(String message, {dynamic error}) {
    if (error != null) {
      log('[Firestore ERROR] $message: $error');
      showErrorBottomSheet("Error", error.toString());
    } else {
      log('[Firestore SUCCESS] $message');
    }
  }

  Future<void> _showConfirmationBottomSheet({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    Get.bottomSheet(
      Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              title,
              style: Get.textTheme.headlineSmall
                  ?.copyWith(color: Get.theme.colorScheme.onErrorContainer),
            ),
            12.verticalSpace,
            Text(
              message,
              style: Get.textTheme.bodyMedium
                  ?.copyWith(color: Get.theme.colorScheme.onErrorContainer),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => Get.back(),
                    child: Text("Batal"),
                    style: FilledButton.styleFrom(
                      backgroundColor: Get.theme.colorScheme.onError,
                      foregroundColor: Get.theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    child: Text("Hapus"),
                  ),
                ),
              ],
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  void _showLoading() {
    Get.bottomSheet(
      const SizedBox(
        height: 150,
        child: LoadingBar(),
      ),
      isDismissible: false,
    );
  }

  void _hideLoading() {
    while (Get.isBottomSheetOpen == true) {
      Get.back();
    }
  }

  /// Creates or updates a document
  Future<void> setDocument(
      String collectionPath, String? docId, Map<String, dynamic> data,
      {bool merge = true}) async {
    try {
      _showLoading();
      await _firestore.collection(collectionPath).doc(docId).set(
        {
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: merge),
      );
      _hideLoading();
      _log('Document set in $collectionPath/$docId');
    } catch (e) {
      _hideLoading();
      _log('Failed to set document in $collectionPath/$docId', error: e);
    }
  }

  /// Updates specific fields in a document
  Future<void> updateDocument(
      String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      _showLoading();
      await _firestore.collection(collectionPath).doc(docId).update(data);
      _log('Document updated in $collectionPath/$docId');
      _hideLoading();
    } catch (e) {
      _hideLoading();
      _log('Failed to update document in $collectionPath/$docId', error: e);
      rethrow;
    }
  }

  /// Deletes a document
  Future<bool> deleteDocument(String collectionPath, String docId) async {
    final completer = Completer<bool>();

    try {
      _showConfirmationBottomSheet(
        title: 'Apakah kamu yakin?',
        message: 'Tindakan ini akan menghapus item secara permanen.',
        onConfirm: () async {
          try {
            await _firestore.collection(collectionPath).doc(docId).delete();
            _log('Document deleted in $collectionPath/$docId');
            completer.complete(true);
          } catch (e) {
            _log('Failed to delete document in $collectionPath/$docId', error: e);
            completer.complete(false);
          }
        },
      );
    } catch (e) {
      _log('Failed to show confirmation for deleting $collectionPath/$docId', error: e);
      completer.complete(false);
    }

    return completer.future;
  }


  Future<void> forceDeleteDocument(String collectionPath, String docId) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      _log('Failed to delete document in $collectionPath/$docId', error: e);
    }
  }

  /// Fetches a single document by ID
  Future<DocumentSnapshot?> getDocument(
      String collectionPath, String docId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collectionPath).doc(docId).get();
      if (doc.exists) {
        _log('Fetched document from $collectionPath/$docId');
        return doc;
      } else {
        _log('Document does not exist in $collectionPath/$docId');
        return null;
      }
    } catch (e) {
      _log('Failed to fetch document from $collectionPath/$docId', error: e);
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot>> getCollection(
      String collectionPath) async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(collectionPath).get();
      _log('Fetched collection from $collectionPath');
      return snapshot.docs;
    } catch (e) {
      _log('Failed to fetch collection from $collectionPath', error: e);
      return [];
    }
  }

  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    try {
      return _firestore.collection(collectionPath);
    } catch (e) {
      _log("Failed to fetch collection from $collectionPath', error: e");
      rethrow;
    }
  }

  WriteBatch batch() {
    try {
      return _firestore.batch();
    } catch (e) {
      _log("Failed to fetch batch', error: e");
      rethrow;
    }
  }
}
