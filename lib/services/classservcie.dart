import 'package:cloud_firestore/cloud_firestore.dart';


import '../model/user/classesmodel.dart';

class ClassesService {
  final FirebaseFirestore firebaseCollection = FirebaseFirestore.instance;

  // Method to fetch all classes for the current professor
  Future<List<ClassesModel>> getClassesForProf(String profId) async {
    try {
      // Step 1: Fetch the professor's document
      DocumentSnapshot profSnapshot = await firebaseCollection
          .collection('profs') // Assuming professors are stored in a 'profs' collection
          .doc(profId)
          .get();

      // Step 2: Extract the array of class IDs from the professor's document
      if (profSnapshot.exists) {
        List<String> classIds = List<String>.from(profSnapshot['classes'] ?? []);

        // Step 3: Fetch the classes based on the class IDs
        List<ClassesModel> classes = [];
        for (String classId in classIds) {
          DocumentSnapshot classSnapshot = await firebaseCollection
              .collection('classes') // Assuming classes are stored in a 'classes' collection
              .doc(classId)
              .get();

          if (classSnapshot.exists) {
            classes.add(ClassesModel.fromJson(classSnapshot));
          }
        }

        return classes;
      } else {
        print('Professor not found');
        return [];
      }
    } catch (e) {
      print('Error fetching classes for professor: $e');
      return [];
    }
  }
}
