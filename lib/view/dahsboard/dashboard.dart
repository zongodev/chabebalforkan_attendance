import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qr_pres/controller/auth_controller.dart';
import 'package:qr_pres/controller/qrcontroller/qr_code_controller.dart';
import 'package:qr_pres/routes/app_routes.dart';
import 'package:qr_pres/view/dahsboard/widgets/dash_card.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController =
    Get.put(AuthController(), permanent: true);
    final QrCodeController qrCodeController = Get.put(QrCodeController());

    // Define dashboard items for professors
    final List<Map<String, dynamic>> profDashItems = [
      {
        'text': 'جداول الأوقات',
        'icon': Icons.calendar_today,
        'path': AppRoutes.profTimeTable
      },
      {
        'text': 'الطلبة في انتظار',
        'icon': Icons.people,
        'path': AppRoutes.studentsWaiting
      },
      {
        'text': 'قائمة الطلاب', // Students List
        'icon': Icons.list, // Icon representing a list
        'path': AppRoutes.studentsList
      },
    ];

    // Define dashboard items for students
    final List<Map<String, dynamic>> studentDashItems = [
      {'text': 'رمزيتي', 'icon': Icons.qr_code, 'path': AppRoutes.myqrcode},
      {
        'text': 'جداول الأوقات',
        'icon': Icons.calendar_month_outlined,
        'path': AppRoutes.timeTable
      },
      {
        'text': 'الجدول الزمني الخاص بي',
        'icon': Icons.timeline,
        'path': '', // No path since it's not implemented
        'notImplemented': true, // Flag to indicate not implemented
      },
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 10,
        onPressed: () {
          showUserInfoDialog(context);
        },
        child: const Icon(
          Icons.person,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bgdash.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.9,
                ),
                borderRadius: BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(20),
                  bottomStart: Radius.circular(100),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        authController.signOut();
                      },
                      icon: Icon(
                        Icons.logout,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(
                  () {
                    final userName ;
                    authController.isProf.value?
                 userName =
                    authController.currentProfData.value?.firstName:userName =
                        authController.currentStudentData.value?.firstName;
                final welcomeText = authController.isProf.value
                    ? 'مرحبًا أستاذ $userName\nشكراً لمساهمتك في تعليم القرآن في جمعية شباب الفرقان' // Welcome Professor
                    : 'مرحبًا طالب $userName\nنتمنى لك تجربة مفيدة في جمعية شباب الفرقان لحفظ وتعليم القرآن'; // Welcome Student

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    welcomeText,
                    style: const TextStyle(
                        fontSize: 15, color: Colors.black, fontFamily: "Kufam"),
                    textDirection: TextDirection.rtl,
                  ),
                );
              },
            ), // Added space between the header and the grid
            Obx(
                  () {
                final itemsToShow = authController.isProf.value
                    ? profDashItems
                    : studentDashItems;
                return Flexible(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: itemsToShow.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15, // Added spacing between rows
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final item = itemsToShow[index];

                      return InkWell(
                        onTap: () async {
                          if (item['text'] == 'رمزيتي') {
                            EasyLoading.show(
                                status: 'جارٍ التحميل...'); // Loading...
                            await qrCodeController.generateQr(
                              authController.currentStudentData.value!.firstName,
                              authController.currentStudentData.value!.lastName,
                              authController.currentStudentData.value!.docId!,
                            );
                            Get.toNamed(item['path']);
                          } else if (item['notImplemented'] == true) {
                            // Show not implemented message
                            Get.snackbar(
                              'تنبيه', // Alert
                              'هذه الميزة قيد التطوير',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                            );
                          } else {
                            Get.toNamed(item['path']);
                          }
                        },
                        child: DashCard(
                          text: item['text'],
                          icon: item['icon'],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showUserInfoDialog(BuildContext context) {
  final AuthController authController = Get.find<AuthController>();
  final userData;
  authController.isProf.value?
  userData= authController.currentProfData.value:userData=authController.currentStudentData.value;
  if (userData == null) return; // Make sure user data is loaded

  TextEditingController firstNameController =
  TextEditingController(text: userData.firstName);
  TextEditingController lastNameController =
  TextEditingController(text: userData.lastName);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 10,
        title: Text('معلومات الملف الشخصي'), // Profile Information
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'الاسم'), // First Name
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'اللقب'), // Last Name
              ),
              TextField(
                controller: TextEditingController(text: userData.email),
                decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
                readOnly: true, // Make email non-editable
              ),
              !authController.isProf.value? TextField(
                controller: TextEditingController(
                    text: authController.classStudent.value), // Class
                decoration: InputDecoration(labelText: 'الفصل الدراسي'), // Class
                readOnly: true, // Make class non-editable
              ):SizedBox(),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.black),
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('إلغاء'), // Cancel
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () async {
              // Update user information
              await authController.updateUserInfo(
                authController.currentUser.value!.uid, // Use the user's ID
                firstNameController.text,
                lastNameController.text,
              );
              Navigator.of(context).pop();
            },
            child: Text('تحديث'), // Update
          ),
        ],
      );
    },
  );
}