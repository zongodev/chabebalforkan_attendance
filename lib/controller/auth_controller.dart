import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_pres/routes/app_pages.dart';
import 'package:qr_pres/routes/app_routes.dart';
import 'package:qr_pres/services/auth_service.dart';
import '../model/user/prof_modal.dart';
import '../model/user/user_model.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();

  Rx<User?> currentUser = Rx<User?>(null);

  // Separate Rx variables for student and professor data
  Rx<StudentModel?> currentStudentData = Rx<StudentModel?>(null);
  Rx<ProfModel?> currentProfData = Rx<ProfModel?>(null);

  final Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  get emailC => _emailController;

  get password => _passwordController;
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final RxBool isProf = RxBool(false);
  final RxString classStudent = RxString('');
  final FirebaseFirestore collectionReference = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    userStream.listen((user) async {
      currentUser.value = user;
      if (user != null) {
        await checkUserType(); // Check if the user is a professor or student
        await fetchUserData(); // Fetch either professor or student data
        log('User email: ${user.email}');

        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  Future<void> checkUserType() async {
    try {
      // Check if the user is a professor
      QuerySnapshot profsSnapshot = await collectionReference
          .collection('profs')
          .where('email', isEqualTo: currentUser.value?.email)
          .get();

      // Set the isProf flag based on the query result
      isProf.value = profsSnapshot.docs.isNotEmpty;
      log('isProf value after query: ${isProf.value}');
    } catch (e) {
      log('Error checking user type: $e');
    }
  }

  Future<void> fetchUserData() async {
    try {
      if (isProf.value) {
        // Fetch professor data
        DocumentSnapshot profDoc = await collectionReference
            .collection('profs')
            .doc(currentUser.value!.uid)
            .get();

        if (profDoc.exists) {
          ProfModel prof = ProfModel.fromDocumentSnapShot(profDoc);
          currentProfData.value = prof; // Set professor data
          log('Professor first name: ${prof.firstName}');
        }
      } else {
        // Fetch student data
        DocumentSnapshot studentDoc = await collectionReference
            .collection('students')
            .doc(currentUser.value!.uid)
            .get();

        if (studentDoc.exists) {
          StudentModel student = StudentModel.fromDocumentSnapShot(studentDoc);
          currentStudentData.value = student; // Set student data
          log('Student first name: ${student.firstName}');
          fetchSubclassName(currentStudentData.value!.classes);
        }
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }
  }

  Future<void> signIn() async {
    try {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        Get.snackbar(
          "خطأ",
          "الرجاء إدخال البريد الإلكتروني وكلمة المرور.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // **Perform Sign-In**
      UserCredential userCredential =
      await authInstance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      log('User signed in successfully: ${userCredential.user?.email}');
      Get.snackbar(
        "نجاح",
        "تم تسجيل الدخول بنجاح.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // **Clear input fields**
      _emailController.clear();
      _passwordController.clear();

      // **No need to navigate here; onInit listener handles it**
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code}');
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "لا يوجد مستخدم بهذا البريد الإلكتروني.";
          break;
        case 'wrong-password':
          errorMessage = "كلمة المرور غير صحيحة.";
          break;
        case 'invalid-email':
          errorMessage = "البريد الإلكتروني غير صالح.";
          break;
        case 'invalid-credential':
          errorMessage = "البريد الإلكتروني غير صالح./ كلمة المرور غير صحيحة.";
          break;
        case 'user-disabled':
          errorMessage = "تم تعطيل هذا المستخدم. يرجى التواصل مع الدعم.";
          break;
        default:
          errorMessage = "حدث خطأ غير معروف. يرجى المحاولة مرة أخرى.";
      }
      Get.snackbar(
        "تعذر تسجيل الدخول",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      log('Error during sign in: $e');
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع. يرجى المحاولة لاحقًا.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await authInstance.signOut();
      currentUser.value = null;
      currentStudentData.value = null;
      currentProfData.value = null;
      Get.offAllNamed(
          AppRoutes.login); // Redirects to the login screen after logout.
      Get.snackbar(
        "تم تسجيل الخروج",
        "تم تسجيل الخروج بنجاح.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      log('Error during sign out: $e');
      Get.snackbar(
        "خطأ",
        "حدثت مشكلة أثناء تسجيل الخروج.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearFields() {
    firstName.clear();
    lastName.clear();
    email.clear();
    pass.clear();
    confirmPass.clear();
  }
  Future<void> registerUser(String selectedClass) async {
    if (firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        email.text.isEmpty ||
        pass.text.isEmpty) {
      Get.snackbar(
        "خطأ",
        "الرجاء ملء جميع الحقول.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Create user with email and password
      UserCredential userCredential =
      await authInstance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text,
      );

      // Create a StudentModel object
      StudentModel student = StudentModel(
        firstName: firstName.text,
        lastName: lastName.text,
        email: email.text,
        isPresent: false,
        isWaiting: false,
        classes: selectedClass,
        docId: userCredential.user?.uid,
      );

      // Add student to Firestore
      await collectionReference
          .collection('students')
          .doc(student.docId)
          .set(student.toMap());

      Get.snackbar(
        "نجاح",
        "تم إنشاء الحساب بنجاح.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear fields after user creation
      clearFields();
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code}');
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "البريد الإلكتروني مستخدم بالفعل.";
          break;
        default:
          errorMessage = "حدث خطأ غير معروف.";
      }
      Get.snackbar(
        "خطأ",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      log('Error creating user: $e');
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // New function to fetch classes
  Future<List<Map<String, dynamic>>> fetchClasses() async {
    try {
      QuerySnapshot querySnapshot =
      await collectionReference.collection('classes').get();
      return querySnapshot.docs.map((doc) {
        return {
          'docId': doc.id,
          'className': doc['className'],
          'subClasses': doc['subClasses'],
        };
      }).toList();
    } catch (e) {
      log("Error fetching classes: $e");
      return []; // Return empty list on error
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllSubClasses() async {
    List<String> allSubClasses = [];
    List<Map<String, dynamic>> subclassNames = [];

    try {
      QuerySnapshot classesSnapshot =
      await collectionReference.collection('classes').get();

      for (var classDoc in classesSnapshot.docs) {
        List<dynamic> subClassesList =
            classDoc['subClasses'] ?? []; // Get subclasses from the document

        for (var subClassId in subClassesList) {
          allSubClasses.add(
            subClassId, // The document ID of the subclass
          );
        }
      }
    } catch (e) {
      log("Error fetching subclasses: $e");
    }
    subclassNames = await fetchSubclassNames(allSubClasses);

    return subclassNames;
  }

  // Fetch subclass names from Firestore based on their document IDs
  Future<List<Map<String, dynamic>>>fetchSubclassNames(List<String> subclassIds) async {
    List<Map<String, dynamic>> subclassNames = [];

    try {
      for (String id in subclassIds) {
        DocumentSnapshot subclassDoc =
        await collectionReference.collection('classes').doc(id).get();
        if (subclassDoc.exists) {
          subclassNames.add(
            {'className':subclassDoc['className'],
              'classId':id,
            },
          ); // Assuming the name field exists
        }
      }
    } catch (e) {
      log("Error fetching subclass names: $e");
    }

    return subclassNames;
  }
  Future<void> fetchSubclassName(String subclassId) async {
    String? subclassName;

    try {
      DocumentSnapshot subclassDoc =
      await collectionReference.collection('classes').doc(subclassId).get();
      if (subclassDoc.exists) {
        subclassName=subclassDoc['className'];
      }

    } catch (e) {
      log("Error fetching subclass names: $e");
    }

    classStudent.value=subclassName!;
  }
  Future<void> updateUserInfo(
      String userId, String firstName, String lastName) async {
    try {
      // Validate inputs
      if (firstName.isEmpty || lastName.isEmpty) {
        Get.snackbar(
          "خطأ",
          "الاسم الأول واسم العائلة مطلوبان.", // First name and last name are required
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (isProf.value) {
        // Update professor info
        await collectionReference.collection('profs').doc(userId).update({
          'firstName': firstName,
          'lastName': lastName,
        });
        if (currentProfData.value != null) {
          currentProfData.value!.firstName = firstName;
          currentProfData.value!.lastName = lastName;
        }
      } else {
        // Update student info
        await collectionReference.collection('students').doc(userId).update({
          'firstName': firstName,
          'lastName': lastName,
        });
        if (currentStudentData.value != null) {
          currentStudentData.value!.firstName = firstName;
          currentStudentData.value!.lastName = lastName;
        }
      }



      Get.snackbar(
        "نجاح",
        "تم تحديث المعلومات بنجاح.", // Information updated successfully
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle error during Firestore update
      log('Error updating user info: $e');
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء تحديث المعلومات. يرجى المحاولة لاحقًا.", // Error updating info, try again later
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

