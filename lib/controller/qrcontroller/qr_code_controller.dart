import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../auth_controller.dart';

class QrCodeController extends GetxController {
  final AuthController authController = Get.put(AuthController());

  @override
  void onInit() async {
 /*   EasyLoading.show(status: 'جارٍ التحميل...'); // Loading...
    await generateQr(
      authController.currentUserData.value!.firstName ,
      authController.currentUserData.value!.lastName ,
      authController.currentUserData.value!.id,
    );*/
    super.onInit();
  }

  RxString qrData = "".obs;
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> generateQr(String name, String lastName, String uid) async {
    String data = "Name: $name\nLast name: $lastName\nUserId: $uid"; // Name, Last name, User ID
    qrData.value = data;
    EasyLoading.dismiss();
    print(qrData.value);
    EasyLoading.showSuccess('تم إنشاء رمز الاستجابة السريعة بنجاح!'); // QR code generated successfully!
    update();
  }

  Future<void> downloadQrCodeImage(GlobalKey qrCodeKey) async {
    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        RenderRepaintBoundary boundary =
        qrCodeKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

        // Capturing the widget as an image
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List? pngBytes = byteData?.buffer.asUint8List();

        if (pngBytes != null) {
          final result = await ImageGallerySaver.saveImage(pngBytes, quality: 100, name: "qrCode");
          if (result["isSuccess"]) {
            EasyLoading.showSuccess('تم حفظ رمز الاستجابة السريعة في المعرض!'); // QR code saved to gallery!
          } else {
            EasyLoading.showError('فشل في حفظ رمز الاستجابة السريعة.'); // Failed to save QR code.
          }
        }
      } else {
        EasyLoading.showError('تم رفض إذن الوصول إلى التخزين.'); // Storage permission denied.
      }
    } catch (e) {
      print("خطأ: $e"); // Error:
    }
  }

}
