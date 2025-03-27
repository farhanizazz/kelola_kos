import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt page = 0.obs;
  static NavigationController get to => Get.find();
}
