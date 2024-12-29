import 'package:get/get.dart';
import 'package:qr_pres/controller/auth_controller.dart';

class AuthBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(AuthController(),permanent: true);
  }

}