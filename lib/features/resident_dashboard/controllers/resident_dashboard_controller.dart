import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/utils/functions/normalize_phone_number.dart';
import 'package:kelola_kos/utils/services/firestore_service.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class ResidentDashboardController extends GetxController {
  final newResidentNameCtrl = TextEditingController();
  final fireStoreClient = Get.find<FirestoreService>();
  final formKey = GlobalKey<FormState>();

  Future<void> editName() async {
    final Future newName = await Get.bottomSheet(
      Container(
        height: Get.height * 0.2,
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  controller: newResidentNameCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration:
                      InputDecoration(labelText: 'Masukkan nama baru'.tr),
                ),
              ),
              Spacer(),
              SizedBox(
                width: 1.sw,
                child: FilledButton.tonal(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      fireStoreClient.updateDocument(
                        'Residents',
                        normalizePhoneNumber(GlobalService.to.selectedResident.value!.phone),
                        {'name': newResidentNameCtrl.text},
                      );
                      Get.back();
                    }

                  },
                  child: Text("Simpan"),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  static ResidentDashboardController get to => Get.find();
}
