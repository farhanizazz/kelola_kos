import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/utils/functions/hide_loading.dart';
import 'package:kelola_kos/utils/functions/show_loading.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  static SupabaseService get to => Get.find<SupabaseService>();
  static final supabase = Supabase.instance.client;

  Future<String> uploadImage(File image) async {
    final timestamp = DateTime
        .now()
        .millisecondsSinceEpoch;
    final fileExtension = image.path
        .split('.')
        .last;
    await supabase.from('images').upsert({
      'image_path':
      'images/${LocalStorageService.box.get(
          LocalStorageConstant.USER_ID)}/$timestamp.$fileExtension',
    });
    return await supabase.storage.from('images').upload(
      '${LocalStorageService.box.get(
          LocalStorageConstant.USER_ID)}/$timestamp.$fileExtension',
      image,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );
  }

  Future<String> uploadInvoice(File invoice, Resident resident) async {
    log('Uploading invoice');
    try {
      final timestamp = DateTime
          .now()
          .millisecondsSinceEpoch;
      final fileExtension = invoice.path
          .split('.')
          .last;
      await supabase.from('invoices').upsert({
        'invoice_path':
        'invoices/${LocalStorageService.box.get(
            LocalStorageConstant.USER_ID)}/$timestamp.$fileExtension',
      });
      showLoading();
      final filepath = await supabase.storage.from('invoices').upload(
        '${LocalStorageService.box.get(
            LocalStorageConstant.USER_ID)}/$timestamp.$fileExtension',
        invoice,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
      hideLoading();
      log(resident.id, name: 'Resident ID');
      FirestoreService.to.setDocument('Residents', resident.id, {
        'invoicePath': filepath,
      });
      log("Filepath: $filepath");
      return filepath;
    } catch (e, st) {
      hideLoading();
      log("Error uploading invoice: $e");
      log('Stack trace: $st');
      rethrow;
    }
  }

  Future<String> getImage(String path) async {
    final now = DateTime.now().toIso8601String();
    await supabase.from('images').update({
      'image_path': path,
      'last_accessed_at': now,
    }).eq('image_path', path);
    final newPath = path.replaceAll('images/', '');
    return await supabase.storage
        .from('images')
        .createSignedUrl(newPath, 60 * 60);
  }
}
