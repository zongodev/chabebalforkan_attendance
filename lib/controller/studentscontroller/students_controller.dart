import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:qr_pres/model/user/precanemodel.dart';

import '../../model/user/coursesModel.dart';
import '../../model/user/user_model.dart';
import '../../services/students_service.dart';

class StudentsController extends GetxController {
  final StudentService studentsService = StudentService();
  RxList<StudentModel?> students = <StudentModel?>[].obs;
  RxList<Course?> courses = <Course?>[].obs;
  RxBool isLoading = true.obs;
  RxnString selectedClassId = RxnString(null);


  void getStudents(String classId) {
    try {
      isLoading.value = true; // Start loading
      studentsService.fetchStudents(classId).listen((event) {
        students.value = event;
        isLoading.value = false; // Stop loading when data is received
      }, onError: (error) {
        log("Error fetching professors: $error");
        isLoading.value = false; // Stop loading on error
      });
    } catch (e) {
      log(e.toString());
      isLoading.value = false; // Stop loading on catch
    }
  }
  Future<void> updateStudentStatus(String studentId, bool newValue) async {
    try {
      // Assuming you are using Firestore
      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .update({'isWaiting': newValue});

    } catch (e) {
      print('Error updating student status: $e');
    }
  }




  DateTime _parseTime(String time) {
    // Split the input string into time and period (AM/PM)
    final parts = time.split(' ').map((part) => part.trim()).toList();

    // Ensure the string has both time and period (AM/PM)
    if (parts.length != 2) {
      throw FormatException('Invalid time format. Expected format: hh:mm AM/PM');
    }

    final hourMinute = parts[0].split(':');

    // Ensure the time part has both hours and minutes
    if (hourMinute.length != 2) {
      throw FormatException('Invalid time format. Expected format: hh:mm');
    }

    // Parse hour and minute
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    // Adjust hour based on AM/PM
    if (parts[1].toUpperCase() == 'PM' && hour != 12) {
      hour += 12;
    } else if (parts[1].toUpperCase() == 'AM' && hour == 12) {
      hour = 0;
    }

    // Return a DateTime object with a fixed date, only the time part matters here
    return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute);
  }
  Future<void> getSessionForClass() async {
    isLoading.value = true;
    final firebaseCollection = FirebaseFirestore.instance;

    QuerySnapshot coursesSnapshot = await firebaseCollection
        .collection('sessions')
        .where('classId', isEqualTo: selectedClassId.value!)
        .get();
    for (QueryDocumentSnapshot doc in coursesSnapshot.docs) {
      Course course = Course.fromDocumentSnapShot(doc);
      print(course.name);
      courses.add(course);
    }
    isLoading.value=false;
  }

  Future<void> confirmPres() async {
    isLoading.value = true;
    final firebaseCollection = FirebaseFirestore.instance;
    DateTime now = DateTime.now();
    List<String> arabicDays = [
      'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
    ];

    try {
      QuerySnapshot coursesSnapshot = await firebaseCollection
          .collection('sessions')
          .where('classId', isEqualTo: selectedClassId.value!)
          .get();

      String? currentCourseId;

      for (QueryDocumentSnapshot doc in coursesSnapshot.docs) {
        Course course = Course.fromDocumentSnapShot(doc);

        DateTime startTime = _parseTime(course.startTime);
        DateTime endTime = _parseTime(course.endTime);

        if (now.isAfter(startTime) && now.isBefore(endTime) &&
            course.day == arabicDays[now.weekday - 1]) {
          currentCourseId = doc.id;
          print(currentCourseId);// Get the course/session ID
          break;
        }
      }

      if (currentCourseId == null) {
        Get.snackbar(
          "حدث خطأ",
          "no course",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        isLoading.value=false;
        return;
      }

      QuerySnapshot studentsSnapshot = await firebaseCollection
          .collection('students')
          .get();

      WriteBatch batch = firebaseCollection.batch();
      List<StudentModel> allStudents = [];

      for (QueryDocumentSnapshot doc in studentsSnapshot.docs) {
        DocumentReference attendanceRef = firebaseCollection
            .collection('sessions')
            .doc(currentCourseId)
            .collection('Attendance')
            .doc();

        batch.set(attendanceRef, {
          'studentId': doc.id,
          'status': doc['isWaiting']==true?'present':'absent',
          'timestamp': FieldValue.serverTimestamp(),
        });
        allStudents.add(StudentModel.fromDocumentSnapShot(doc));
        DocumentReference studentRef = firebaseCollection.collection('students').doc(doc.id);
        batch.update(studentRef, {'isPresent': true, 'isWaiting': false});

        // Add attendance document in the Attendance subcollection under the session

      }

      //PModel pModel = PModel(confirmDate: currentCourseId, classId: selectedClassId.value!, studentsConfirmed: allStudents);

      await batch.commit();
      // await sendSessionInfo(pModel);
      Get.back();
      Get.snackbar(
        "تم تأكيد الحضور بنجاح",
        "تم تحديث حالة جميع الطلاب الذين كانوا في الانتظار.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        "حدث خطأ",
        "لم يتم تأكيد الحضور. يرجى المحاولة مرة أخرى.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      print('Error updating student presence: $e');
    }
  }

  /*Future<void> sendSessionInfo(PModel info) async {
    FirebaseFirestore.instance.collection('sessionInfo').add(info.toMap());
  }*/

}