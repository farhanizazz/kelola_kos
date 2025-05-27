import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> showConfirmationBottomSheet({
  required String title,
  required String message,
  required VoidCallback onConfirm,
  Color? backgroundColor,
  Color? foregroundColor,
}) async {
  backgroundColor ??= Get.theme.colorScheme.errorContainer;
  foregroundColor ??= Get.theme.colorScheme.onErrorContainer;

  Get.bottomSheet(
    Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
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
                ?.copyWith(color: foregroundColor),
          ),
          12.verticalSpace,
          Text(
            message,
            style: Get.textTheme.bodyMedium
                ?.copyWith(color: foregroundColor),
          ),
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => Get.back(),
                  child: Text("Batal"),
                  style: FilledButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
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