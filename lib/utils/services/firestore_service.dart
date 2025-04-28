import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/shared/widgets/loading_bar.dart';
import 'package:kelola_kos/utils/functions/show_confirmation_bottom_sheet.dart';
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

  Future<void> setDocumentIfNotExists(
      String collectionPath,
      String? docId,
      Map<String, dynamic> data,
      ) async {
    try {
      _showLoading();
      final docRef = _firestore.collection(collectionPath).doc(docId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        await docRef.set({
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
        });
        _log('Document created at $collectionPath/$docId');
        _hideLoading();
      } else {
        _log('Document at $collectionPath/$docId already exists. Skipped write.');
        _hideLoading();
        showErrorBottomSheet('Error', 'Penghuni sudah ada, silahkan buat penghuni baru dengan nomor telepon yang berbeda');
      }
    } catch (e) {
      _log('Failed to set document at $collectionPath/$docId', error: e);
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
      showConfirmationBottomSheet(
        title: 'Apakah kamu yakin?',
        message: 'Tindakan ini akan menghapus item secara permanen.',
        onConfirm: () async {
          try {
            _showLoading();
            await _firestore.collection(collectionPath).doc(docId).delete();
            _log('Document deleted in $collectionPath/$docId');
            _hideLoading();
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

  Future<List<QueryDocumentSnapshot>> searchCollection({
    required String collectionPath,
    required String searchText,
    int limit = 10,
  }) async {
    try {
      final token = searchText.trim().toLowerCase();

      if (token.isEmpty) return [];

      QuerySnapshot snapshot = await _firestore
          .collection(collectionPath)
          .where('search_token', arrayContains: token)
          .limit(limit)
          .get();

      _log('Searched token "$token" in $collectionPath');
      _log('Found ${snapshot.docs.length} documents');

      return snapshot.docs;
    } catch (e) {
      _log('Failed to search token "$searchText" in $collectionPath', error: e);
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
