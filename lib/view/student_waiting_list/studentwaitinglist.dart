import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_pres/controller/classescontroller/classescontroller.dart';
import 'package:qr_pres/controller/studentscontroller/students_controller.dart';
import 'package:qr_pres/view/student_waiting_list/widgets/studentlistforwidgets.dart';

class StudentsWaitingList extends StatefulWidget {
  const StudentsWaitingList({Key? key}) : super(key: key);

  @override
  State<StudentsWaitingList> createState() => _StudentsWaitingListState();
}

class _StudentsWaitingListState extends State<StudentsWaitingList> {
  final StudentsController studentsController = Get.put(StudentsController());
  final ClassesController classesController = Get.put(ClassesController());
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلاب في قائمة الانتظار'), // Waiting Students
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
                            studentsController.getStudents(
                                classesController.classes[index]!.classId!);
                            studentsController.selectedClassId.value=classesController.classes[index]!.classId!;
                            studentsController.getSessionForClass();
                          });
                          print(
                              classesController.classes.value[index]?.classId);
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? Colors.purple.withOpacity(
                                0.3) // Change color if selected
                                : Colors.transparent,
                            // Default color when not selected
                            border: Border.all(color: Colors.purple),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                              child: Text(classesController.classes[index]!
                                  .className)), // Display class name
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: studentsController.courses.length,
                  itemBuilder: (context, index) {
                  return ListTile(
                    onTap: ()=>Get.to( StudentListForSession(selectedIndex: selectedIndex, studentsController: studentsController,sessionId:studentsController.courses.value[index]!.id!),),
                    title: Text('${studentsController.courses.value[index]?.name}'),
                    trailing: const Icon(Icons.arrow_right_outlined),
                  );
                },),
              )
             
            ],
          );
        }
      }),
    );
  }
}


