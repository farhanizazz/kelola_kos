import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:kelola_kos/constants/asset_constant.dart';
import 'package:kelola_kos/constants/local_storage_constant.dart';
import 'package:kelola_kos/shared/models/user.dart';
import 'package:kelola_kos/shared/styles/google_text_style.dart';
import 'package:kelola_kos/shared/widgets/language_choice_chip.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/local_storage_service.dart';

class ProfileController extends GetxController {
  final RxBool notificationStatus = false.obs;
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController languageCtrl = TextEditingController();
  final TextEditingController fullNameCtrl = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  var currentLocale = Rx<Locale>(Get.locale ?? Locale('id', 'ID'));
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    languageCtrl.text = Get.locale == Locale('id', 'ID') ? 'Indonesia'.tr : 'English'.tr;
    nameCtrl.text = LocalStorageService.box.get(LocalStorageConstant.NAME);
    emailCtrl.text = LocalStorageService.box.get(LocalStorageConstant.EMAIL);
    phoneCtrl.text = LocalStorageService.box.get(LocalStorageConstant.PHONE);
    fullNameCtrl.text =
        LocalStorageService.box.get(LocalStorageConstant.FULLNAME);
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value == null || !emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().length < 8) {
      return 'Invalid phone number';
    }
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name cannot be empty';
    }
    return null;
  }

  Future<void> updateProfile() async {
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;

    final newUserData = FirestoreUser(
      uid: LocalStorageService.box.get(LocalStorageConstant.USER_ID),
      email: emailCtrl.text,
      name: nameCtrl.text,
      fullName: fullNameCtrl.text,
      phoneNumber: phoneCtrl.text,);
    await firestoreService.updateDocument(
      'users',
      LocalStorageService.box.get(LocalStorageConstant.USER_ID),
      newUserData.toMap(),
    );
    LocalStorageService.setAuth(newUserData);
  }

  void changeLanguage(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(30)),
        height: 210,
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Container(
                width: 100,
                height: 4,
                decoration: BoxDecoration(
                    color: Get.theme.dividerColor,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            15.verticalSpace,
            Text(
              "Ganti Bahasa",
              style: GoogleTextStyle.fw700.copyWith(fontSize: 18.sp),
            ),
            15.verticalSpace,
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Obx(() => LanguageChoiceChip(
                    name: "Indonesia",
                    flagAsset: AssetConstant.icIndoFlag,
                    isSelected: currentLocale.value == Locale('id', 'ID'),
                    onTap: () => _changeLocale(Locale('id', 'ID')),
                  )),
                ),
                15.horizontalSpace,
                Expanded(
                  child: Obx(() => LanguageChoiceChip(
                    name: "Inggris",
                    flagAsset: AssetConstant.icEngFlag,
                    isSelected: currentLocale.value == Locale('en', 'US'),
                    onTap: () => _changeLocale(Locale('en', 'US')),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _changeLocale(Locale locale) {
    currentLocale.value = locale;
    Get.updateLocale(locale);
    languageCtrl.text = Get.locale == Locale('id', 'ID') ? 'Indonesia'.tr : 'English'.tr;
  }

  static ProfileController get to => Get.find();
}
