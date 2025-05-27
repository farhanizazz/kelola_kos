import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/shared/widgets/loading_bar.dart';

void showLoading() {
  Get.bottomSheet(
    const SizedBox(
      height: 150,
      child: LoadingBar(),
    ),
    isDismissible: false,
  );
}