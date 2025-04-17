
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_dorm/constants/add_dorm_assets_constant.dart';
import 'package:kelola_kos/features/add_dorm/controllers/add_dorm_controller.dart';
import 'package:kelola_kos/shared/widgets/custom_tonal_button.dart';
import 'package:kelola_kos/utils/functions/price_format.dart';

class AddDormScreen extends StatelessWidget {
  AddDormScreen({super.key});

  final assetsConstant = AddDormAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
        child: FilledButton(
          onPressed: () {
            AddDormController.to.addDorm();
          },
          child: Text(Get.arguments == null ? "Tambahkan Kos" : "Ubah Kos"),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: AddDormController.to.formKey,
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
                        'Tambah Kos Baru',
                        style: Get.textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  14.verticalSpace,
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Nama Kos'),
                    validator: AddDormController.to.validateField,
                    controller: AddDormController.to.dormNameController,
                  ),
                  12.verticalSpace,
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Lokasi'),
                    validator: AddDormController.to.validateField,
                    controller: AddDormController.to.locationController,
                  ),
                  12.verticalSpace,
                  // TextFormField(
                  //   decoration: InputDecoration(hintText: 'Url Gambar'),
                  //   validator: AddDormController.to.validateImageUrl,
                  //   controller: AddDormController.to.imageUrlController,
                  // ),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(hintText: 'Keterangan'),
                    controller: AddDormController.to.noteController,
                  ),
                  12.verticalSpace,
                Obx(() {
                  final controller = AddDormController.to;
                  final image = controller.dormImage.value;
                  final imageUrl = controller.imageUrl.value;

                  Widget child;

                  if (image != null) {
                    child = Image.file(image, fit: BoxFit.cover);
                  } else if (imageUrl.isNotEmpty) {
                    child = CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover);
                  } else {
                    child = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 60.w,
                          color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        Text(
                          'Tambahkan gambar kos',
                          style: TextStyle(
                            color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    );
                  }

                  return GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      height: 200,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: child),
                    ),
                  );
                }),
                24.verticalSpace,
                  Text(
                    "Detail Ruangan",
                    style: Get.textTheme.headlineSmall,
                  ),
                  Obx(
                    () => ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final room = AddDormController.to.rooms[index];
                        return Animate(
                          effects: [
                            FadeEffect(duration: 300.ms),
                            // Smooth fade-in effect
                            SlideEffect(
                                begin: Offset(0, 0.2),
                                end: Offset.zero,
                                duration: 300.ms),
                            // Slide from bottom
                          ],
                          key: ValueKey(index),
                          child: ListTile(
                            subtitleTextStyle: Get.theme.textTheme.bodySmall,
                            contentPadding: EdgeInsets.zero,
                            title: Text(room.roomName),
                            subtitle: Text("${room.price.formatPrice()}/Bulan"),
                            trailing: IconButton(
                              onPressed: () {
                                AddDormController.to.deleteRoom(index);
                              },
                              icon: Icon(Icons.delete,
                                  color: Get.theme.colorScheme.error),
                            ),
                          ),
                        );
                      },
                      itemCount: AddDormController.to.rooms.length,
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: AddDormController.to.rooms.isEmpty,
                      child: 12.verticalSpace,
                    ),
                  ),
                  TonalButton(
                    onPressed: () {
                      AddDormController.to.addRoom();
                    },
                    child: Text("+ Kamar"),
                  ),
                  12.verticalSpace
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
