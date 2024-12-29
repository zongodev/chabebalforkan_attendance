import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../controller/studentscontroller/students_controller.dart';
class StudentListForSession extends StatelessWidget {
  const StudentListForSession({
    super.key,
    required this.selectedIndex,
    required this.studentsController,
    required this.sessionId,
  });

  final int selectedIndex;
  final String sessionId;
  final StudentsController studentsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('welcome'),),
      body: selectedIndex != -1
          ? Obx(() {
        if (studentsController.students.isEmpty && !studentsController.isLoading.value) {
          return const Center(child: Text('لا يوجد طلاب في الانتظار')); // No students waiting
        } else if (studentsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        else {
          return Column(
            children: [
              Text(sessionId),
              Expanded(
                child: ListView.builder(
                  itemCount: studentsController.students.length,
                  itemBuilder: (context, index) {
                    final student = studentsController.students[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 2,
                      child: ListTile(
                        title: Text('اسم الطالب: ${student?.firstName}'), // Student Name
                        subtitle: Text('البريد الإلكتروني: ${student?.email}'), // Email
                        trailing: Switch(
                          value: student!.isWaiting,
                          onChanged: (newValue) {
                            studentsController.updateStudentStatus(student.docId!, newValue);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    studentsController.confirmPres();
                  },
                  child: const Text('تأكيد الحضور'), // Confirm presence
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 18,fontFamily: 'Kufam'),
                  ),
                ),
              ),
            ],
          );
        }
      })
          : const Center(child: Text('يرجى اختيار فصل')),
    );
  }
}