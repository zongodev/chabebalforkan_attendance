import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/sessioncontroller/sessioncontroller.dart';
import '../../model/user/coursesModel.dart';

class TimeTableUI extends StatelessWidget {
  final SessionController sessionController = Get.put(SessionController());

  @override
  Widget build(BuildContext context) {
    final List<String> daysOfWeek = ["الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('جدول الأوقات'), // "Timetable"
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Handle loading state
          if (sessionController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // If no courses are available
          if (sessionController.courses.isEmpty) {
            return const Center(child: Text('لا توجد بيانات للعرض')); // "No data to display"
          }

          final List<Course?> courses = sessionController.courses;

          // Create a set to hold unique time slots
          final Set<String> timeSlotsSet = {};

          // Populate the set with time slots from the courses
          for (var course in courses) {
            if (course != null) {
              timeSlotsSet.add(course.startTime); // Add start time
              timeSlotsSet.add(course.endTime);   // Add end time
            }
          }

          // Convert set to list and sort it
          List<String> timeSlots = timeSlotsSet.toList();
          timeSlots.sort((a, b) => _parseTime(a).compareTo(_parseTime(b)));

          // Create a list of TableRow for the timetable
          List<TableRow> tableRows = [];

          // Header Row
          tableRows.add(
            TableRow(
              decoration: const BoxDecoration(color: Colors.blueAccent),
              children: [
                const TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('الساعة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // "Hour"
                  ),
                ),
                ...daysOfWeek.map((day) {
                  return TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(day, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              ],
            ),
          );

          // Data Rows
          for (int i = 0; i < timeSlots.length - 1; i++) {
            // Check if there is at least one course for the current time slot
            final hasCourse = daysOfWeek.any((day) {
              return courses.any((course) =>
              course?.day == day &&
                  course?.startTime == timeSlots[i]);
            });

            if (hasCourse) {
              // Create a table row only if there is data for the time slot
              tableRows.add(
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${timeSlots[i]} - ${timeSlots[i + 1]}'), // Keep the time slots in the original format
                      ),
                    ),
                    ...daysOfWeek.map((day) {
                      final course = courses.firstWhere(
                            (course) => course?.day == day && course?.startTime == timeSlots[i],
                        orElse: () => Course(name: "", startTime: "", endTime: "", day: ""),
                      );
                      return TableCell(
                        child: Container(
                          color: course!.name.isNotEmpty ? Colors.lightBlue : Colors.transparent,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(course.name.isNotEmpty ? course.name : '')),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }
          }

          // Build the table once the data is ready
          return SingleChildScrollView(
            child: Table(
              border: TableBorder.all(),
              children: tableRows,
            ),
          );
        }),
      ),
    );
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
}
