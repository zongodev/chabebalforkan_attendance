import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_pres/model/user/coursesModel.dart';

class CoursesService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<Course>> getCourses(String classId) {
    return firebaseFirestore.collection('sessions').where(
        'classId', isEqualTo: classId).snapshots().map((event) {
          return
          event.docs.map((e) =>  Course.fromDocumentSnapShot(e)).toList();
        });
  }
}