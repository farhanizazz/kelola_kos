import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_resident/constants/add_resident_assets_constant.dart';
import 'package:kelola_kos/features/add_resident/controllers/add_resident_controller.dart';
import 'package:kelola_kos/features/add_resident/repositories/add_resident_repository.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class AddResidentScreen extends StatelessWidget {
  AddResidentScreen({Key? key}) : super(key: key);

  final assetsConstant = AddResidentAssetsConstant();

  @override
  Widget build(BuildContext context) {
    log(GlobalService.to.selectedResident.value.toString(), name: 'Selected resident');
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
        child: FilledButton(
          onPressed: () async {
            await AddResidentController.to.addResident();
          },
          child: Obx(() => Text(AddResidentController.to.isEdit.value
              ? 'Ubah Penghuni'.tr
              : 'Tambahkan Penghuni'.tr)),
        ),
      ),
      body: SafeArea(
        child: Padding(
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
                      Obx(
                        () => Text(
                          AddResidentController.to.isEdit.value
                              ? 'Ubah Penghuni'
                              : 'Tambah Penghuni',
                          style: Get.textTheme.headlineLarge,
                        ),
                      ),
                    ],
                  ),
                  14.verticalSpace,
                  Visibility(
                    visible: GlobalService.to.selectedResident.value == null,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text('Nama Penghuni'.tr),
                          ),
                          controller:
                              AddResidentController.to.residentNameController,
                          validator: AddResidentController.to.validateField,
                        ),
                        12.verticalSpace,
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Nomor Telepon Penghuni'.tr),
                    ),
                    controller:
                        AddResidentController.to.residentPhoneController,
                    validator: AddResidentController.to.validateField,
                  ),
                  Visibility(
                    visible: GlobalService.to.selectedResident.value == null,
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Obx(
                        () => Column(
                          children: [
                            12.verticalSpace,
                            DropdownMenu(
                              controller:
                                  AddResidentController.to.dormController,
                              width: constraint.maxWidth,
                              initialSelection: null,
                              label: Text('Kos'),
                              dropdownMenuEntries:
                                  AddResidentController.to.dorms
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
                          ],
                        ),
                      );
                    }),
                  ),
                  Obx(
                    () => Visibility(
                      visible: AddResidentController.to.rooms.isNotEmpty,
                      child: Column(
                        children: [
                          12.verticalSpace,
                          LayoutBuilder(builder: (context, constraint) {
                            return DropdownMenu(
                              controller:
                                  AddResidentController.to.roomController,
                              width: constraint.maxWidth,
                              initialSelection: null,
                              label: Text('Ruangan'.tr),
                              dropdownMenuEntries:
                                  AddResidentController.to.rooms
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
                    decoration: InputDecoration(
                      label: Text('Tanggal Masuk'),
                      hintText: 'Tanggal Masuk',
                    ),
                    controller: AddResidentController.to.paymentDateController,
                    readOnly: true,
                    onTap: () {
                      int selectedDay = 0;
                      int selectedMonth = 0;
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => Container(
                          height: 216,
                          padding: const EdgeInsets.only(top: 6.0),
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          color: CupertinoColors.systemBackground
                              .resolveFrom(context),
                          child: SafeArea(
                            top: false,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Obx(
                                        () => Expanded(
                                          child: CupertinoPicker(
                                            magnification: 1.22,
                                            squeeze: 1.2,
                                            useMagnifier: true,
                                            itemExtent: 32,
                                            scrollController:
                                                FixedExtentScrollController(
                                              initialItem: AddResidentController
                                                          .to.payDay.value !=
                                                      null
                                                  ? AddResidentController
                                                      .to.payDay.value!
                                                  : 0,
                                            ),
                                            onSelectedItemChanged:
                                                (int selectedItem) {
                                              selectedDay = selectedItem;
                                            },
                                            children: List<Widget>.generate(
                                                AddResidentRepository
                                                    .days.length, (int index) {
                                              return Center(
                                                  child: Text(
                                                      AddResidentRepository
                                                          .days[index]));
                                            }),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Expanded(
                                          child: CupertinoPicker(
                                            magnification: 1.22,
                                            squeeze: 1.2,
                                            useMagnifier: true,
                                            itemExtent: 32,
                                            scrollController:
                                                FixedExtentScrollController(
                                              initialItem: AddResidentController
                                                          .to.payMonth.value !=
                                                      null
                                                  ? AddResidentController
                                                      .to.payMonth.value!
                                                  : 0,
                                            ),
                                            onSelectedItemChanged:
                                                (int selectedItem) {
                                              selectedMonth = selectedItem;
                                            },
                                            children: List<Widget>.generate(
                                                AddResidentRepository.months
                                                    .length, (int index) {
                                              return Center(
                                                  child: Text(
                                                      AddResidentRepository
                                                          .months[index]));
                                            }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FilledButton(
                                      onPressed: () {
                                        AddResidentController.to.payDay.value =
                                            selectedDay;
                                        AddResidentController
                                            .to.payMonth.value = selectedMonth;
                                        Get.back();
                                      },
                                      child: Text('Simpan'.tr)),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    validator: AddResidentController.to.validateField,
                  ),
                  Visibility(
                    visible: GlobalService.to.selectedResident.value == null,
                    child: Column(
                      children: [
                        12.verticalSpace,
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Catatan (Optional)".tr),
                          maxLines: 5,
                        ),
                        12.verticalSpace,
                        Obx(
                          () => Visibility(
                            visible: AddResidentController.to.isEdit.value,
                            child: Row(
                              children: [
                                Switch(
                                    value: AddResidentController
                                        .to.paymentStatus.value,
                                    onChanged: (value) {
                                      AddResidentController
                                              .to.paymentStatus.value =
                                          !AddResidentController
                                              .to.paymentStatus.value;
                                    }),
                                5.horizontalSpace,
                                Text('Status Pembayaran'.tr),
                                Spacer(),
                                Obx(
                                    () => Visibility(
                                    visible: (AddResidentController.to.resident.value?.invoicePath ?? '') != '',
                                    child: ElevatedButton(
                                      onPressed: () {
                                        AddResidentController.to.launchPdf();
                                      },
                                      child: Text("Lihat Invoice"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        12.verticalSpace,
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      12.verticalSpace,
                      LayoutBuilder(builder: (context, constraint) {
                        return Obx(
                          () => DropdownMenu(
                            controller: AddResidentController
                                .to.notificationIntervalController,
                            width: constraint.maxWidth,
                            initialSelection: AddResidentController
                                .to.notificationInterval.value,
                            label: Text('Ingatkan Setiap'),
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                value: Duration(days: 30),
                                label: '1 Bulan sekali',
                              ),
                              DropdownMenuEntry(
                                value: Duration(days: 90),
                                label: '3 Bulan sekali',
                              ),
                              DropdownMenuEntry(
                                value: Duration(days: 180),
                                label: '6 Bulan sekali',
                              ),
                              DropdownMenuEntry(
                                value: Duration(days: 360),
                                label: '1 Tahun sekali',
                              ),
                            ],
                            onSelected: (value) {
                              if (value != null) {
                                AddResidentController
                                    .to.notificationInterval.value = value;
                              }
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
