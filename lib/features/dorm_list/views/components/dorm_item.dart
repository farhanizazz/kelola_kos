import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DormItem extends StatelessWidget {
  const DormItem({
    super.key,
    required this.name,
    required this.residentAmount,
    required this.residentMax,
    required this.location,
    this.imageUrl,
    this.onTap, this.trailing,
  });

  final String name;
  final int residentAmount;
  final int residentMax;
  final String location;
  final void Function()? onTap;
  final Widget? trailing;
  final String? imageUrl;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? 'https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg',
              height: 220.h,
              width: 1.sw,
              fit: BoxFit.cover,
            ),
          ),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Get.textTheme.headlineSmall,
                  ),
                  5.verticalSpace,
                  Text(
                    "${"Penghuni".tr}: $residentAmount/$residentMax, $location",
                    style: Get.textTheme.bodySmall
                        ?.copyWith(color: Get.theme.disabledColor),
                  ),
                ],
              ),
              trailing == null ? const SizedBox() : trailing!,
            ],
          ),
        ],
      ),
    );
  }
}
