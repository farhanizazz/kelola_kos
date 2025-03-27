import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_resident/constants/add_resident_assets_constant.dart';
import 'package:kelola_kos/features/add_resident/controllers/add_resident_controller.dart';

class AddResidentScreen extends StatelessWidget {
  AddResidentScreen({Key? key}) : super(key: key);

  final assetsConstant = AddResidentAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
        child: FilledButton(
          onPressed: () {
            AddResidentController.to.addResident();
          },
          child: Text("Tambahkan Penghuni"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: AddResidentController.to.formKey,
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
                        icon: Icon(Icons.arrow_back_ios_new)),
                    5.horizontalSpace,
                    Text(
                      'Tambah Penghuni',
                      style: Get.textTheme.headlineLarge,
                    ),
                  ],
                ),
                14.verticalSpace,
                TextFormField(
                  decoration: InputDecoration(hintText: 'Nama Penghuni'),
                  controller: AddResidentController.to.residentNameController,
                  validator: AddResidentController.to.validateField,
                ),
                12.verticalSpace,
                TextFormField(
                  decoration:
                      InputDecoration(hintText: 'Nomor Telepon Penghuni'),
                  controller: AddResidentController.to.residentPhoneController,
                  validator: AddResidentController.to.validateField,
                ),
                12.verticalSpace,
                LayoutBuilder(builder: (context, constraint) {
                  return Obx(
                    () => DropdownMenu(
                      controller: AddResidentController.to.dormController,
                      width: constraint.maxWidth,
                      initialSelection: null,
                      hintText: 'Kos',
                      dropdownMenuEntries: AddResidentController.to.dorms
                          .map(
                            (dorm) => DropdownMenuEntry(
                              value: dorm.id,
                              label: dorm.name,
                            ),
                          )
                          .toList(),
                      onSelected: (value) {
                        if (value != null) {
                          AddResidentController.to.changeDorm(value);
                        }
                      },
                    ),
                  );
                }),
                Obx(
                  () => Visibility(
                    visible: AddResidentController.to.rooms.isNotEmpty,
                    child: Column(
                      children: [
                        12.verticalSpace,
                        LayoutBuilder(builder: (context, constraint) {
                          return DropdownMenu(
                            controller: AddResidentController.to.roomController,
                            width: constraint.maxWidth,
                            initialSelection: null,
                            hintText: 'Ruangan',
                            dropdownMenuEntries: AddResidentController.to.rooms
                                .map(
                                  (room) => DropdownMenuEntry(
                                    value: room.id,
                                    label: room.roomName,
                                  ),
                                )
                                .toList(),
                            onSelected: (value) {
                              if (value != null) {
                                AddResidentController.to.changeRoom(value);
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                12.verticalSpace,
                TextFormField(
                  decoration: InputDecoration(hintText: "Catatan (Optional)"),
                  maxLines: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
