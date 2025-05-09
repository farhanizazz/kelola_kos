import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> showConfirmationBottomSheet({
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) async {
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
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => Get.back(),
                  child: Text("Batal"),
                  style: FilledButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.onError,
                    foregroundColor: Get.theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Get.back();
                    onConfirm();
                  },
                  child: Text("Konfirmasi"),
                ),
              ),
            ],
          ),
          20.verticalSpace,
        ],
      ),
    ),
  );
}