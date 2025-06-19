import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/features/add_ticket/constants/add_ticket_assets_constant.dart';

class AddTicketScreen extends StatelessWidget {
  AddTicketScreen({Key? key}) : super(key: key);

  final assetsConstant = AddTicketAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
        child: FilledButton(
          onPressed: () {

          },
          child: Text("Buat Ticket"),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              // key: AddDormController.to.formKey,
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
                        'Tambah Ticket baru',
                        style: Get.textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  14.verticalSpace,
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Nama Kos'),
                    // validator: AddDormController.to.validateField,
                    // controller: AddDormController.to.dormNameController,
                  ),
                  12.verticalSpace,
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Lokasi'),
                    // validator: AddDormController.to.validateField,
                    // controller: AddDormController.to.locationController,
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
                    // controller: AddDormController.to.noteController,
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
