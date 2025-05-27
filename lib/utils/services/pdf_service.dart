import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/utils/functions/file_save_helper.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';


class PdfService extends GetxService {
  static PdfService get to => Get.find<PdfService>();

  final PdfDocument document = PdfDocument();


  Future<String> generatePDF({
    required String residentName,
    required String ownerName,
    required String roomNumber,
    required double rentAmount,
    required String paymentDate,
    required String paymentMethod,
    required String invoiceNumber,
    required String status,
    String fileName = 'dorm_invoice.pdf',
  }) async {
    try {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final Size pageSize = page.getClientSize();
      final PdfGraphics graphics = page.graphics;

      final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
      final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

      graphics.drawString(
        'Dorm Payment Invoice',
        titleFont,
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 40),
      );

      double y = 60;
      void drawText(String label, String value) {
        graphics.drawString('$label:', contentFont, bounds: Rect.fromLTWH(0, y, 150, 20));
        graphics.drawString(value, contentFont, bounds: Rect.fromLTWH(160, y, pageSize.width - 160, 20));
        y += 25;
      }

      drawText('Invoice Number', invoiceNumber);
      drawText('Invoice Date', paymentDate);
      drawText('Resident Name', residentName);
      drawText('Room Number', roomNumber);
      drawText('Owner Name', ownerName);
      drawText('Monthly Rent', '\$${rentAmount.toStringAsFixed(2)}');
      drawText('Payment Status', status);
      drawText('Payment Method', paymentMethod);

      y += 30;
      graphics.drawString(
        'Note: This invoice serves as a receipt of payment.',
        contentFont,
        bounds: Rect.fromLTWH(0, y, pageSize.width, 20),
      );

      final List<int> bytes = await document.save();
      document.dispose();
      final filepath = await FileSaveHelper.saveAndLaunchFile(bytes, fileName, launch: false);
      return filepath;
    } catch (e, st) {
      // Consider logging or reporting this error in production
      log("Error generating PDF: $e");
      log('Stack trace: $st');
      rethrow;
    }
  }


}