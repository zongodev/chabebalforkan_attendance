  import 'package:cloud_firestore/cloud_firestore.dart';

  class StudentModel {
     String firstName;
     String lastName;
    final String email;
    String? imageUrl;
    final bool isPresent;
     bool isWaiting;
    String? docId;
    final String classes;


    StudentModel({
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.isPresent,
      required this.isWaiting,
      this.docId,
      this.imageUrl,
      required this.classes,

    });

    factory StudentModel.fromDocumentSnapShot(DocumentSnapshot jsonData) {
      return StudentModel(
        docId: jsonData.id,
        firstName: jsonData['firstName'],
        lastName: jsonData['lastName'],
        email: jsonData['email'],
        isPresent: jsonData['isPresent'],
        imageUrl: jsonData['imageUrl'],
        isWaiting: jsonData['isWaiting'],
        classes: jsonData['classes'],
      );
    }

    Map<String, dynamic> toMap() {
      return {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'isPresent': isPresent,
        'isWaiting': isWaiting,
        'imageUrl': imageUrl,
        'classes': classes,
        'id':docId
      };
    }
  }
