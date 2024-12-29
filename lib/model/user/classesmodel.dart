import 'package:cloud_firestore/cloud_firestore.dart';

class ClassesModel {
  String className;
  String? classId;
  List<String>? subClasses;  // New field to hold subclasses

  ClassesModel({
    required this.className,
    this.classId,
    this.subClasses,
  });

  Map<String, dynamic> toMap() { // Updated toMap
    return {
      'className': className,
      'subClasses': subClasses ?? [],
    };
  }

  factory ClassesModel.fromJson(DocumentSnapshot data) {
    return ClassesModel(
      classId: data.id,
      className: data['className'],
      subClasses: List<String>.from(data['subClasses'] ?? []),
    );
  }
}
