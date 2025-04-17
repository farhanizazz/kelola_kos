import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/constants/asset_constant.dart';
import 'package:kelola_kos/features/dashboard/views/ui/dashboard_screen.dart';
import 'package:kelola_kos/features/dorm_list/views/ui/dorm_list_screen.dart';
import 'package:kelola_kos/features/navigation/constants/navigation_assets_constant.dart';
import 'package:kelola_kos/features/navigation/controllers/navigation_controller.dart';
import 'package:kelola_kos/features/profile/views/ui/profile_screen.dart';
import 'package:kelola_kos/features/resident_list/views/ui/resident_list_screen.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({Key? key}) : super(key: key);

  final assetsConstant = NavigationAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          unselectedItemColor: Get.theme.disabledColor,
          selectedItemColor: Get.theme.colorScheme.onSurface,
          showUnselectedLabels: true,
          currentIndex: NavigationController.to.page.value,
          onTap: (index) {
            NavigationController.to.page.value = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetConstant.icHome),
              activeIcon: SvgPicture.asset(
                AssetConstant.icHome,
                colorFilter: ColorFilter.mode(
                    Get.theme.colorScheme.onSurface, BlendMode.srcIn),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetConstant.icDorm),
              activeIcon: SvgPicture.asset(
                AssetConstant.icDorm,
                colorFilter: ColorFilter.mode(
                    Get.theme.colorScheme.onSurface, BlendMode.srcIn),
              ),
              label: 'Kos Anda'.tr,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetConstant.icResident),
              activeIcon: SvgPicture.asset(
                AssetConstant.icResident,
                colorFilter: ColorFilter.mode(
                    Get.theme.colorScheme.onSurface, BlendMode.srcIn),
              ),
              label: 'Penghuni'.tr,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetConstant.icPerson),
              activeIcon: SvgPicture.asset(
                AssetConstant.icPerson,
                colorFilter: ColorFilter.mode(
                    Get.theme.colorScheme.onSurface, BlendMode.srcIn),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(
            () => SafeArea(
              child: IndexedStack(
                        index: NavigationController.to.page.value,
                        children: [
              DashboardScreen(),
              DormListScreen(),
              ResidentListScreen(),
              ProfileScreen(),
                        ],
                      ),
            ),
      ),
    );
  }
}
