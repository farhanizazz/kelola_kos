import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/dorm_list/constants/dorm_list_assets_constant.dart';
import 'package:kelola_kos/features/dorm_list/controllers/dorm_list_controller.dart';
import 'package:kelola_kos/features/dorm_list/views/components/dorm_item.dart';

class DormListScreen extends StatelessWidget {
  DormListScreen({super.key});

  final assetsConstant = DormListAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Tambah Kos"),
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
                  'Semua Kos Anda',
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
                    return DormItem(
                      name: dorm.name,
                      imageUrl: dorm.image,
                      location: dorm.location,
                      residentAmount: dorm.residentCount,
                      residentMax: dorm.rooms.length,
                      onTap: () {
                        Get.toNamed(Routes.detailDormRoute, arguments: dorm.id);
                      },
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) {
                          switch (value) {
                            case 'edit':
                              Get.toNamed(Routes.addDormRoute, arguments: dorm);
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
                              style:
                                  TextStyle(color: Get.theme.colorScheme.error),
                            ),
                          ),
                        ],
                        icon: Icon(Icons.more_vert), // Keep the three-dot icon
                      ),
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
