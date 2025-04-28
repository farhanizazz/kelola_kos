import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/shared/models/dorm.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';

class SearchController extends GetxController {
  final searchQueryController = TextEditingController();
  final RxString _debouncedQuery = ''.obs;
  final RxList<Dorm> searchResults = <Dorm>[].obs;

  @override
  void dispose() {
    searchQueryController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    // Bind listener to update RxString
    searchQueryController.addListener(() {
      _debouncedQuery.value = searchQueryController.text;
    });

    // Debounce with 500ms delay before triggering _searchDorm
    debounce(_debouncedQuery, (String value) {
      if (value.isNotEmpty) {
        _searchDorm(value);
      }
    }, time: const Duration(milliseconds: 500));

    super.onInit();
  }

  Future<void> _searchDorm(String query) async {
    final result = await FirestoreService.to.searchCollection(
      collectionPath: 'Dorms',
      searchText: query,
    );

    final dorms = result.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // inject the document ID
      return Dorm.fromMap(data);
    }).toList();

    searchResults.assignAll(dorms);
  }

  static SearchController get to => Get.find();
}
