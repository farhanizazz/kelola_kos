import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/dorm_list/constants/dorm_list_assets_constant.dart';
import 'package:kelola_kos/features/dorm_list/controllers/dorm_list_controller.dart';
import 'package:kelola_kos/features/dorm_list/views/components/dorm_item.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/supabase_service.dart';
import 'package:shimmer/shimmer.dart';

class DormListScreen extends StatelessWidget {
  DormListScreen({super.key});

  final assetsConstant = DormListAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'tambah_kos',
        icon: Icon(Icons.add),
        label: Text('Tambah Kos'.tr),
        onPressed: () {
          Get.toNamed(Routes.addDormRoute);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              25.verticalSpace,
              SizedBox(
                width: 250,
                child: Text(
                  'Semua Kos Anda'.tr,
                  style: Get.textTheme.headlineLarge,
                ),
              ),
              25.verticalSpace,
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final dorm = DormListController.to.dorms[index];
                    return FutureBuilder<String>(
                        future: SupabaseService.getImage(dorm.image ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Shimmer.fromColors(
                              baseColor: Get.theme.colorScheme.surfaceContainer,
                              highlightColor: Get.theme.colorScheme.surfaceContainer.withOpacity(0.5),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Get.theme.colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return const SizedBox(
                              height: 200,
                              child: Center(child: Text('Gagal memuat gambar')),
                            );
                          }

                          final imageUrl = snapshot.data ?? '';

                          return Obx(
                            () => DormItem(
                              name: dorm.name,
                              imageUrl: imageUrl,
                              location: dorm.location,
                              residentAmount: GlobalService.to.residents
                                  .where((resident) => resident.dormId == dorm.id)
                                  .length,
                              residentMax: GlobalService.to.rooms
                                  .where((room) => room.dormId == dorm.id)
                                  .length,
                              onTap: () {
                                Get.toNamed(Routes.detailDormRoute,
                                    arguments: dorm.id);
                              },
                              trailing: PopupMenuButton<String>(
                                onSelected: (String value) {
                                  switch (value) {
                                    case 'edit':
                                      Get.toNamed(Routes.addDormRoute,
                                          arguments: dorm);
                                      break;
                                    case 'delete':
                                      DormListController.to.deleteDorm(dorm.id!);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Get.theme.colorScheme.error),
                                    ),
                                  ),
                                ],
                                icon: const Icon(Icons.more_vert),
                              ),
                            ),
                          );
                        },
                      );
                  },
                  separatorBuilder: (context, index) => 12.verticalSpace,
                  itemCount: DormListController.to.dorms.length,
                ),
              ),
              12.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
