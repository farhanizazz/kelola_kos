import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/constants/asset_constant.dart';
import 'package:kelola_kos/features/splash/constants/splash_assets_constant.dart';
import 'package:kelola_kos/shared/widgets/custom_tonal_button.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final assetsConstant = SplashAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AssetConstant.appLogo
        ),
      ),
    );
  }
}
