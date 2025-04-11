import 'dart:io';

import 'package:get/get.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  static final supabase = Supabase.instance.client;

  static Future<String> uploadImage(File image) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileExtension = image.path.split('.').last;
    await supabase.from('images').upsert({
      'image_path':
          'images/${LocalStorageService.box.get(LocalStorageConstant.USER_ID)}/$timestamp.$fileExtension',
    });
    return await supabase.storage.from('images').upload(
          '${LocalStorageService.box.get(LocalStorageConstant.USER_ID)}/$timestamp.$fileExtension',
          image,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
  }

  static Future<String> getImage(String path) async {
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
