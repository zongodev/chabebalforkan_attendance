import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_pres/controller/classescontroller/classescontroller.dart';
import 'package:qr_pres/controller/studentscontroller/students_controller.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({Key? key}) : super(key: key);

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  final StudentsController studentsController = Get.put(StudentsController());
  final ClassesController classesController = Get.put(ClassesController());
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الطلاب'), // Students List
      ),
      body: Obx(() {
        if (classesController.classes.isEmpty && !classesController.isLoading.value) {
          return const Center(child: Text('لا توجد فصول مخصصة لهذا المعلم')); // No classes assigned to this prof
        } else if (classesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              SizedBox(
                height: 40,
                child: ListView.builder(
                  itemCount: classesController.classes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            studentsController.getStudents(classesController.classes[index]!.classId!);
                            studentsController.selectedClassId.value = classesController.classes[index]!.classId!;
                          });
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: selectedIndex == index ? Colors.purple.withOpacity(0.3) : Colors.transparent, // Change color if selected
                            border: Border.all(color: Colors.purple),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Text(classesController.classes[index]!.className), // Display class name
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: selectedIndex != -1
                    ? Obx(() {
                  if (studentsController.students.isEmpty && !studentsController.isLoading.value) {
                    return const Center(child: Text('لا يوجد طلاب في الانتظار')); // No students waiting
                  } else if (studentsController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      children: [
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
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16), // Space below the list
                      ],
                    );
                  }
                })
                    : const Center(child: Text('يرجى اختيار فصل')), // Please select a class
              ),
            ],
          );
        }
      }),
    );
  }
}
