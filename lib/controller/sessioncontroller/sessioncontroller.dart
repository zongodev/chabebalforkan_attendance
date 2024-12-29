import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:qr_pres/model/user/coursesModel.dart';

import '../../services/coursesservice.dart';
import '../auth_controller.dart';

class SessionController extends GetxController {
  final CoursesService coursesService = CoursesService();
  final AuthController authController = Get.put(AuthController(),permanent: true);

  RxList<Course?> courses = <Course?>[].obs;
  RxBool isLoading = true.obs;
  RxInt selectedIndex = (-1).obs ;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(authController.isProf.value==false){
    getCourses(authController.currentStudentData.value!.classes);}

  }
  void getCourses(String classId) {
    try {
      isLoading.value = true; // Start loading
      coursesService.getCourses(classId).listen((event) {
        courses.value = event;
        isLoading.value = false; // Stop loading when data is received
      }, onError: (error) {
        log("Error fetching professors: $error");
        isLoading.value = false; // Stop loading on error
      });
    } catch (e) {
      log(e.toString());
      isLoading.value = false; // Stop loading on catch
    }
    update();
  }
}