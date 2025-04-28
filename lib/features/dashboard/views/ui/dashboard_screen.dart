import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/constants/asset_constant.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/features/dashboard/constants/dashboard_assets_constant.dart';
import 'package:kelola_kos/features/dashboard/controllers/dashboard_controller.dart';
import 'package:kelola_kos/features/navigation/controllers/navigation_controller.dart';
import 'package:kelola_kos/features/splash/view/components/custom_card.dart';
import 'package:kelola_kos/features/dashboard/views/components/custom_list_item.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';
import 'package:kelola_kos/utils/services/supabase_service.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final assetsConstant = DashboardAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            25.verticalSpace,
            SizedBox(
                width: 250,
                child: Obx(
                  () => Text(
                    '${'Halo'.tr} ${DashboardController.to.displayName}!',
                    style: Get.textTheme.headlineLarge,
                  ),
                )),
            20.verticalSpace,
            Hero(
              tag: 'search',
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.searchRoute);
                },
                child: AbsorbPointer(
                  child: SearchBar(
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    hintText: "Cari kos".tr,
                    leading: Icon(
                      Icons.search,
                      color: Get.theme.disabledColor,
                    ),
                  ),
                ),
              ),
            ),
            36.verticalSpace,
            Wrap(
              spacing: 12, // Horizontal spacing
              runSpacing: 12, // Vertical spacing
              children: [
                CustomCard(
                  icon: Icon(Icons.visibility_outlined),
                  title: "Lihat Kos".tr,
                  onTap: () {
                    NavigationController.to.page.value = 1;
                  },
                ),
                CustomCard(
                  icon: SvgPicture.asset(
                    AssetConstant.icEdit,
                    colorFilter: ColorFilter.mode(
                        Get.theme.colorScheme.onSurface, BlendMode.srcIn),
                  ),
                  title: "Kelola Penghuni".tr,
                  onTap: () {
                    NavigationController.to.page.value = 2;
                  },
                ),
                Obx(
                  () => CustomCard(
                      icon: SvgPicture.asset(
                        AssetConstant.icResident,
                        colorFilter: ColorFilter.mode(
                            Get.theme.colorScheme.onSurface, BlendMode.srcIn),
                      ),
                      title:
                          "${DashboardController.to.residentsTotal} ${'Penghuni'.tr}"),
                ),
                CustomCard(icon: Icon(Icons.star_outline), title: "Favorite"),
              ],
            ),
            32.verticalSpace,
            Text(
              '${"Kos Anda".tr} ${kDebugMode ? LocalStorageService.box.get(LocalStorageConstant.USER_ID) : ''}',
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            10.verticalSpace,
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final dorm = DashboardController.to.dorms[index];
                  return GestureDetector(
                    onLongPressStart: (details) async {
                      final RenderBox overlay = Overlay.of(context)
                          .context
                          .findRenderObject() as RenderBox;

                      final selectedValue = await showMenu(
                        context: context,
                        position: RelativeRect.fromRect(
                          details.globalPosition & Size(40, 40),
                          // Position where the user tapped
                          Offset.zero & overlay.size,
                        ),
                        items: [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(
                              'Edit Kos',
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'Hapus Kos',
                              style:
                                  TextStyle(color: Get.theme.colorScheme.error),
                            ),
                          ),
                        ],
                      );
                      if (selectedValue == 'delete') {
                        DashboardController.to.deleteDorm(dorm.id!);
                      } else if (selectedValue == 'edit') {
                        Get.toNamed(Routes.addDormRoute, arguments: dorm);
                      }
                    },
                    child: FutureBuilder<String>(
                      future: SupabaseService.getImage(dorm.image ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            baseColor: Get.theme.colorScheme.surfaceContainer,
                            highlightColor: Get.theme.colorScheme.surfaceContainer.withOpacity(0.5),
                            child: Container(
                              height: 64,
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
                            () => CustomListItem(
                            onTap: () => Get.toNamed(Routes.detailDormRoute,
                                arguments: dorm.id),
                            image: imageUrl,
                            dormName: dorm.name,
                            maxResident: GlobalService.rooms.where((room) => room.dormId == dorm.id).length,
                            residentCount: GlobalService.residents.where((resident) => resident.dormId == dorm.id).length,
                          ),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => 10.verticalSpace,
                itemCount: DashboardController.to.dorms.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
