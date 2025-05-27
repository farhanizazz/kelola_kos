///Dart import
import 'dart:io';

///Package imports
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// ignore: avoid_classes_with_only_static_members
///To save the pdf file in the device
class FileSaveHelper {
  static const MethodChannel _platformCall = MethodChannel('launchFile');

  /// Saves the file to device storage and launches it.
  /// Returns the file path of the saved file.
  static Future<String> saveAndLaunchFile(
      List<int> bytes,
      String fileName,
      {bool launch = true}
      ) async {
    String? path;
    if (Platform.isIOS || Platform.isLinux || Platform.isWindows) {
      final Directory directory = await getApplicationSupportDirectory();
      path = directory.path;
    } else if (Platform.isAndroid) {
      final Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        path = directory.path;
      } else {
        final Directory fallback = await getApplicationSupportDirectory();
        path = fallback.path;
      }
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }

    final String fullPath =
    Platform.isWindows ? '$path\\$fileName' : '$path/$fileName';
    final File file = File(fullPath);
    await file.writeAsBytes(bytes, flush: true);

    if (launch) {
      try {
        if (Platform.isAndroid || Platform.isIOS) {
          await OpenFile.open(file.path);
        } else if (Platform.isWindows) {
          await Process.run('start', <String>[fullPath], runInShell: true);
        } else if (Platform.isMacOS) {
          await Process.run('open', <String>[fullPath], runInShell: true);
        } else if (Platform.isLinux) {
          await Process.run('xdg-open', <String>[fullPath], runInShell: true);
        }
      } catch (e) {
        throw Exception('Failed to open file: $e');
      }
    }

    return fullPath;
  }
}
