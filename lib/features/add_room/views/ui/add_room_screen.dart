
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_room/constants/add_room_assets_constant.dart';
import 'package:kelola_kos/features/add_room/controllers/add_room_controller.dart';
import 'package:kelola_kos/shared/widgets/custom_tonal_button.dart';

class AddRoomScreen extends StatelessWidget {
  AddRoomScreen({super.key});

  final assetsConstant = AddRoomAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: AddRoomController.to.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                25.verticalSpace,
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios_new),
                    ),
                    Text(
                      Get.arguments != null
                          ? 'Ubah Ruangan'
                          : 'Tambah Ruangan Baru',
                      style: Get.textTheme.headlineLarge,
                    ),
                  ],
                ),
                14.verticalSpace,
                TextFormField(
                  decoration: InputDecoration(hintText: 'Nama Ruangan'),
                  controller: AddRoomController.to.roomNameController,
                  validator: AddRoomController.to.validateRoomName,
                ),
                12.verticalSpace,
                TextFormField(
                  decoration: InputDecoration(hintText: 'Harga'),
                  keyboardType: TextInputType.number,
                  controller: AddRoomController.to.priceController,
                  validator: AddRoomController.to.validatePrice,
                ),
                12.verticalSpace,
                TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(hintText: 'Keterangan'),
                  controller: AddRoomController.to.notesController,
                ),
                Spacer(),
                FilledButton(
                    onPressed: () {
                      if (Get.arguments == null) {
                        AddRoomController.to.addRoom();
                      } else {
                        AddRoomController.to.editRoom();
                      }
                    },
                    child: Text(Get.arguments != null
                        ? "Ubah Ruangan"
                        : "Tambahkan Ruangan")),
                12.verticalSpace,
                TonalButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Batal")),
                12.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
