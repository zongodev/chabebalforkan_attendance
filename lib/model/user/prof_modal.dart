import 'package:cloud_firestore/cloud_firestore.dart';

class ProfModel {
   String firstName;
   String lastName;
  final String email;
  final String id;


  ProfModel(
      {required this.firstName, required this.lastName, required this.email,required this.id });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'id':id,
    };
  }

  factory ProfModel.fromDocumentSnapShot(DocumentSnapshot jsonData) {
    return ProfModel(
      firstName: jsonData['firstName'],
      lastName: jsonData['lastName'],
      email: jsonData['email'],
      id: jsonData['id'],
    );
  }
}