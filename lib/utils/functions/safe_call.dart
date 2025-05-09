import 'dart:developer';

import 'package:get/get.dart';
import 'package:kelola_kos/utils/functions/show_error_bottom_sheet.dart';

Future<T?> safeCall<T>(Future<T> Function() action) async {
  try {
    return await action();
  } catch (e, stack) {
    log(e.toString(), stackTrace: stack, name: 'SafeCall');
    if(Get.isBottomSheetOpen == true) {
      Get.back();
    }
    showErrorBottomSheet('Oops, something went wrong!',e.toString());
    return null;
  }
}