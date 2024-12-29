import 'dart:developer';

import 'package:get/get.dart';
import 'package:qr_pres/model/user/classesmodel.dart';
import 'package:qr_pres/services/classservcie.dart';

import '../auth_controller.dart';

class ClassesController extends GetxController{
  RxList<ClassesModel?> classes = <ClassesModel?>[].obs;
  final ClassesService classesService = ClassesService();
  final AuthController authController = Get.put(AuthController(),permanent: true);

  @override
  void onInit() {
    super.onInit();
    getClasses(authController.currentUser.value!.uid);
  }

  RxBool isLoading = true.obs;
  Future<void> getClasses(String profId) async {
    try {
      isLoading.value = true; // Start loading
     classes.value=await classesService.getClassesForProf(authController.currentUser.value!.uid);
     isLoading.value=false;
    } catch (e) {
      log(e.toString());
      isLoading.value = false; // Stop loading on catch
    }
    update();
  }

}