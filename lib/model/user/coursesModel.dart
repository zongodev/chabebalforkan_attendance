import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String name;
  final String day;
  final String startTime;
  final String endTime;
  final String? id;

  Course({
    required this.name,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.id
  });
  factory Course.fromDocumentSnapShot(DocumentSnapshot jsonData) {
    return Course(
      id:jsonData.id,
      name: jsonData['licenseName'],
      day: jsonData['weekDay'],
      startTime: jsonData['startDate'],
      endTime: jsonData['endDate'],
    );
  }
}