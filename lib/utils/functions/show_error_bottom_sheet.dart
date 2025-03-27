import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void showErrorBottomSheet(String title, String message) {

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
          FilledButton(
            onPressed: () => Get.back(),
            child: Text("Dismiss"),
            style: FilledButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.onError,
              foregroundColor: Get.theme.colorScheme.onErrorContainer,
            ),
          ),
          20.verticalSpace
        ],
      ),
    ),
  );
}
