import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../routes/app_routes.dart';

class WaitingForApprovalScreen extends StatelessWidget {
  const WaitingForApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('students')
              .where('id', isEqualTo: auth.currentUser.value!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("في انتظار المسؤول ...");
            }

            var userData = snapshot.data!.docs.first.data() as Map<String, dynamic>;

            if (userData['isWaiting'] == false) {
              Future.microtask(() => Get.offAllNamed(AppRoutes.dashboard));
            }

            return const Text("في انتظار موافقة المسؤول...");
          },
        ),
      ),
    );
  }
}
