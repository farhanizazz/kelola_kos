import 'package:get/get.dart';

void hideLoading() {
  while (Get.isBottomSheetOpen == true) {
    Get.back();
  }
}