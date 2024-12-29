import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user/user_model.dart';

class StudentService {
  FirebaseFirestore firebaseCollection = FirebaseFirestore.instance;

  Stream<List<StudentModel>> fetchStudents(String classId) {
    return firebaseCollection
        .collection('students')
        .where('classes', isEqualTo: classId)
        .snapshots()
        .map((QuerySnapshot event) {
      return event.docs.map((e) => StudentModel.fromDocumentSnapShot(e)).toList();
    });
  }



}
