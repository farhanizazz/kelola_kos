import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/dashboard/controllers/dashboard_controller.dart';
import 'package:kelola_kos/features/dashboard/features/search/constants/search_assets_constant.dart';
import 'package:kelola_kos/features/dashboard/features/search/controllers/search_controller.dart'
    as search;
import 'package:kelola_kos/features/dashboard/views/components/custom_list_item.dart';
import 'package:kelola_kos/utils/services/global_service.dart';
import 'package:kelola_kos/utils/services/supabase_service.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final assetsConstant = SearchAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              8.verticalSpace,
              Hero(
                tag: 'search',
                child: SearchBar(
                  autoFocus: true,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  controller: search.SearchController.to.searchQueryController,
                  hintText: "Cari kos".tr,
                  leading: Icon(
                    Icons.search,
                    color: Get.theme.disabledColor,
                  ),
                ),
              ),
              12.verticalSpace,
              Expanded(
                child: Obx(
                  () => ListView.separated(
                      shrinkWrap: true,
                      itemCount:
                          search.SearchController.to.searchResults.length,
                      separatorBuilder: (context, index) => 10.verticalSpace,
                      itemBuilder: (context, index) {
                        final dorm = search.SearchController.to.searchResults[index];
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
                            future: SupabaseService.to.getImage(dorm.image ?? ''),
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
                                  maxResident: GlobalService.to.rooms.where((room) => room.dormId == dorm.id).length,
                                  residentCount: GlobalService.to.residents.where((resident) => resident.dormId == dorm.id).length,
                                ),
                              );
                            },
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
