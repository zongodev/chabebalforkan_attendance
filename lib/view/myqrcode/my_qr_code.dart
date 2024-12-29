import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../../controller/qrcontroller/qr_code_controller.dart';

class MyQrCode extends StatelessWidget {
  const MyQrCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QrCodeController qrCodeController = Get.put(QrCodeController());
    GlobalKey qrCodeKey = GlobalKey();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => qrCodeController.downloadQrCodeImage(qrCodeKey),
        backgroundColor: Colors.green,
        child: const Icon(Icons.download, color: Colors.white),
      ),
      appBar: AppBar(backgroundColor:Colors.green ,),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 280,
                  height: 250,
                  child: Card(
                    color: Colors.white,
                    elevation: 12,
                    shadowColor: Colors.black38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                RepaintBoundary(
                  key: qrCodeKey,
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: Obx(
                          () => PrettyQrView.data(
                        data: qrCodeController.qrData.value,
                        decoration: const PrettyQrDecoration(
                          background: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'يمكنك تحميل رمز الاستجابة السريعة الخاص بك بالضغط على زر "تصدير" واستخدامه في حالة عدم وجود اتصال بالإنترنت.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
