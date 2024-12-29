import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_pres/model/user/user_model.dart';

class PModel {
  final String confirmDate;
  final String classId;
  final List<StudentModel> studentsConfirmed;



  PModel({
    required this.confirmDate,
    required this.classId,
    required this.studentsConfirmed,


  });

  factory PModel.fromDocumentSnapShot(DocumentSnapshot jsonData) {
    return PModel(
      confirmDate: jsonData['confirmDate'],
      classId: jsonData['classId'],
      studentsConfirmed: List<StudentModel>.from(jsonData['studentsConfirmed']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'confirmDate': confirmDate,
      'classId': classId,
      'studentsConfirmed': studentsConfirmed.map((student) => student.toMap()).toList(),
    };
  }
}
