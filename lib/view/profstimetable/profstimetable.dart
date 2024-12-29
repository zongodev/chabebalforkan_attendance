import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/classescontroller/classescontroller.dart';
import '../../controller/sessioncontroller/sessioncontroller.dart';
import '../../model/user/coursesModel.dart';

class ProfTimeTable extends StatelessWidget {
  const ProfTimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClassesController classesController = Get.put(ClassesController());
    final SessionController sessionController = Get.put(SessionController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('جدول الأعمال'), // Emploi de temps
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Obx(() {
              if (classesController.classes.isEmpty && !classesController.isLoading.value) {
                return const Center(child: Text('لا توجد فصول مخصصة لهذا المعلم')); // No classes assigned to this prof
              } else if (classesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: classesController.classes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: InkWell(
                        onTap: () {
                          sessionController.selectedIndex.value = index;
                          sessionController.getCourses(classesController.classes[index]!.classId!);
                        },
                        child: Obx(
                              () => Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: sessionController.selectedIndex.value == index
                                  ? Colors.purple.withOpacity(0.3)
                                  : Colors.transparent,
                              border: Border.all(color: Colors.purple),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                classesController.classes[index]!.className,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: sessionController.selectedIndex.value == index ? Colors.purple : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
          Expanded(
            child: Obx(() {
              final courses = sessionController.courses;
              if (sessionController.selectedIndex.value == -1) {
                return Center(child: const Text('يرجى اختيار فصل')); // Please select a class
              }
              if (sessionController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              List<String> daysOfWeek = ["الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة"];

              final Set<String> timeSlotsSet = {};
              for (var course in courses) {
                if (course != null) {
                  timeSlotsSet.add(course.startTime);
                  timeSlotsSet.add(course.endTime);
                }
              }

              List<String> timeSlots = timeSlotsSet.toList();
              timeSlots.sort((a, b) => _parseTime(a).compareTo(_parseTime(b)));

              List<TableRow> tableRows = []; // Create a list to hold TableRow objects

              for (int i = 0; i < timeSlots.length - 1; i++) {
                // Check if there is at least one course for the current time slot
                final hasCourse = daysOfWeek.any((day) {
                  return courses.any((course) =>
                  course?.day == day &&
                      course?.startTime == timeSlots[i]
                  );
                });

                if (hasCourse) {
                  // Create a table row only if there is data for the time slot
                  tableRows.add(
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${timeSlots[i]} - ${timeSlots[i + 1]}'),
                          ),
                        ),
                        ...daysOfWeek.map((day) {
                          final course = courses.firstWhere(
                                (course) =>
                            course?.day == day &&
                                course?.startTime == timeSlots[i],
                            orElse: () => Course(name: "", startTime: "", endTime: "", day: ""),
                          );
                          return TableCell(
                            child: Container(
                              color: course!.name.isNotEmpty ? Colors.lightBlue : Colors.transparent,
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  course.name.isNotEmpty ? course.name : '',
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: Colors.blueAccent),
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'الوقت', // Heure
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          ...daysOfWeek.map((day) => TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                day,
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                        ],
                      ),
                      ...tableRows, // Add the populated rows here
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

DateTime _parseTime(String time) {
  final parts = time.split(' ');
  final hourMinute = parts[0].split(':');
  int hour = int.parse(hourMinute[0]);
  if (parts[1] == 'PM' && hour != 12) {
    hour += 12;
  } else if (parts[1] == 'AM' && hour == 12) {
    hour = 0;
  }
  final minute = int.parse(hourMinute[1]);
  return DateTime(1970, 1, 1, hour, minute);
}
