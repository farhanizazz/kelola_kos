import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:kelola_kos/features/add_dorm/bindings/add_dorm_binding.dart';
import 'package:kelola_kos/features/add_dorm/views/ui/add_dorm_screen.dart';
import 'package:kelola_kos/features/add_resident/bindings/add_resident_binding.dart';
import 'package:kelola_kos/features/add_resident/views/ui/add_resident_screen.dart';
import 'package:kelola_kos/features/add_room/bindings/add_room_binding.dart';
import 'package:kelola_kos/features/dashboard/bindings/dashboard_binding.dart';
import 'package:kelola_kos/features/dashboard/features/search/bindings/search_binding.dart';
import 'package:kelola_kos/features/dashboard/features/search/views/ui/search_screen.dart';
import 'package:kelola_kos/features/detail_dorm/bindings/detail_dorm_binding.dart';
import 'package:kelola_kos/features/detail_dorm/views/ui/detail_dorm_screen.dart';
import 'package:kelola_kos/features/dorm_list/bindings/dorm_list_binding.dart';
import 'package:kelola_kos/features/forgot_password/bindings/forgot_password_binding.dart';
import 'package:kelola_kos/features/forgot_password/views/ui/forgot_password_screen.dart';
import 'package:kelola_kos/features/login/bindings/login_binding.dart';
import 'package:kelola_kos/features/login/views/ui/login_screen.dart';
import 'package:kelola_kos/features/login_penghuni/bindings/login_penghuni_binding.dart';
import 'package:kelola_kos/features/login_penghuni/features/otp_verification/bindings/otp_verification_binding.dart';
import 'package:kelola_kos/features/login_penghuni/features/otp_verification/views/ui/otp_verification_screen.dart';
import 'package:kelola_kos/features/login_penghuni/views/ui/login_penghuni_screen.dart';
import 'package:kelola_kos/features/navigation/bindings/navigation_binding.dart';
import 'package:kelola_kos/features/navigation/views/ui/navigation_screen.dart';
import 'package:kelola_kos/features/notification/bindings/notification_binding.dart';
import 'package:kelola_kos/features/notification/views/ui/notification_screen.dart';
import 'package:kelola_kos/features/profile/bindings/profile_binding.dart';
import 'package:kelola_kos/features/register/bindings/register_binding.dart';
import 'package:kelola_kos/features/register/views/ui/register_screen.dart';
import 'package:kelola_kos/features/resident_dashboard/bindings/resident_dashboard_binding.dart';
import 'package:kelola_kos/features/resident_dashboard/views/ui/resident_dashboard_screen.dart';
import 'package:kelola_kos/features/resident_list/bindings/resident_list_binding.dart';
import 'package:kelola_kos/features/splash/bindings/splash_binding.dart';
import 'package:kelola_kos/features/splash/view/ui/splash_screen.dart';

import '../../features/add_room/views/ui/add_room_screen.dart';

abstract class Pages {
  static final pages = [
    GetPage(
      name: Routes.splashRoute,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
        name: Routes.loginRoute,
        page: () => LoginScreen(),
        binding: LoginBinding(),
    ),
    GetPage(
        name: Routes.registerRoute,
        page: () => RegisterScreen(),
        binding: RegisterBinding(),
    ),
    GetPage(
        name: Routes.addDormRoute,
        page: () => AddDormScreen(),
        binding: AddDormBinding(),
    ),
    GetPage(
        name: Routes.addRoomRoute,
        page: () => AddRoomScreen(),
        binding: AddRoomBinding(),
    ),
    GetPage(
      name: Routes.addResidentRoute,
      page: () => AddResidentScreen(),
      binding: AddResidentBinding(),
    ),
    GetPage(
      name: Routes.detailDormRoute,
      page: () => DetailDormScreen(),
      binding: DetailDormBinding(),
    ),
    GetPage(
      name: Routes.searchRoute,
      page: () => SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: Routes.residentDashboard,
      page: () => ResidentDashboardScreen(),
      binding: ResidentDashboardBinding(),
    ),
    GetPage(
      name: Routes.residentLogin,
      page: () => LoginPenghuniScreen(),
      binding: LoginPenghuniBinding(),
    ),
    GetPage(
      name: Routes.notificationRoute,
      page: () => NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.otpVerification,
      page: () => OtpVerificationScreen(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: Routes.forgotPasswordRoute,
      page: () => ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
        name: Routes.navigationRoute,
        page: () => NavigationScreen(),
        bindings: [
          NavigationBinding(),
          DashboardBinding(),
          DormListBinding(),
          ResidentListBinding(),
          ProfileBinding(),
        ],
        transition: Transition.noTransition,
        transitionDuration: Duration(milliseconds: 400),
        curve: Curves.easeInOut
    ),
  ];
}
