import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.dormName,
    required this.residentCount,
    required this.maxResident,
    this.image,
    this.onTap,
  });

  final String dormName;
  final int residentCount;
  final int maxResident;
  final void Function()? onTap;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image ?? 'https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg',
              width: 80,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          15.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dormName,
                style: Get.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                "Residents: ${residentCount.toString()}/${maxResident.toString()}",
                style: Get.textTheme.bodySmall
                    ?.copyWith(color: Get.theme.disabledColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
