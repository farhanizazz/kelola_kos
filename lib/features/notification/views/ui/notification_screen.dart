import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/notification/constants/notification_assets_constant.dart';
import 'package:kelola_kos/shared/models/change_request.dart';
import 'package:kelola_kos/shared/models/request_status_enum.dart';
import 'package:kelola_kos/shared/repositories/main_repository.dart';
import 'package:kelola_kos/utils/functions/time_ago_compact.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  final assetsConstant = NotificationAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Text(
                'Notifikasi',
                style: Get.textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                itemCount: GlobalService.to.changeRequests.length,
                itemBuilder: (context, index) {
                  final ChangeRequest changeRequest =
                      GlobalService.to.changeRequests[index];
                  return Ink(
                    decoration: BoxDecoration(
                      color: changeRequest.status == RequestStatus.pending
                          ? Get.theme.colorScheme.surfaceContainerHigh
                          : null,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0.w, vertical: 8.0.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            changeRequest.title,
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            changeRequest.body,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            timeAgoCompact(changeRequest.createdAt),
                            style: TextStyle(
                              color: Get.theme.hintColor,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Visibility(
                            visible:
                                changeRequest.status == RequestStatus.pending,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    MainRepository.updateRequestStatus(
                                        changeRequest.id,
                                        RequestStatus.accepted);
                                  },
                                  child: Text(
                                    'Terima',
                                    style: TextStyle(
                                        color: Get.theme.colorScheme.primary),
                                  ),
                                ),
                                SizedBox(width: 16.0.w),
                                GestureDetector(
                                  onTap: () {
                                    MainRepository.updateRequestStatus(
                                        changeRequest.id,
                                        RequestStatus.declined);
                                  },
                                  child: Text(
                                    'Tolak',
                                    style: TextStyle(
                                        color: Get.theme.colorScheme.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 16.0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
