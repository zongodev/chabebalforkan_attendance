import 'package:get/get.dart';
import 'package:qr_pres/controller/auth_binding.dart';
import 'package:qr_pres/routes/app_routes.dart';
import 'package:qr_pres/view/dahsboard/dashboard.dart';
import 'package:qr_pres/view/landing_screen.dart';
import 'package:qr_pres/view/login/login.dart';
import 'package:qr_pres/view/myqrcode/my_qr_code.dart';
import 'package:qr_pres/view/profstimetable/profstimetable.dart';
import 'package:qr_pres/view/register/register.dart';
import 'package:qr_pres/view/student_waiting_list/studentwaitinglist.dart';
import 'package:qr_pres/view/studentsList/studentlist.dart';
import 'package:qr_pres/view/timetable/time_table.dart';

import '../view/waitingaprove/waitingapprove.dart';

class AppPages {
static final pages =[
  GetPage(name: AppRoutes.initial, page: ()=>const LandingScreen()),
  GetPage(name: AppRoutes.myqrcode, page: ()=>const MyQrCode()),
  GetPage(name: AppRoutes.login, page: ()=>const Login(),binding: AuthBinding()),
  GetPage(name: AppRoutes.register, page: ()=>const Register(),binding: AuthBinding()),
  GetPage(name: AppRoutes.dashboard, page: ()=>const DashBoard()),
  GetPage(name: AppRoutes.timeTable, page: ()=>  TimeTableUI()),
  GetPage(name: AppRoutes.profTimeTable, page: ()=>  ProfTimeTable()),
  GetPage(name: AppRoutes.waiting, page: ()=> WaitingForApprovalScreen()),
  GetPage(name: AppRoutes.studentsWaiting, page: ()=> const StudentsWaitingList()),
  GetPage(name: AppRoutes.studentsList, page: ()=> const StudentsList()),
  // GetPage(name: AppRoutes.classes, page: ()=> const StudentsWaitingList()),
];
}