import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_pres/model/user/prof_modal.dart';

import '../model/user/user_model.dart';

class AuthService {
   final FirebaseAuth auth = FirebaseAuth.instance;
   final FirebaseFirestore collectionReference = FirebaseFirestore.instance;



   Future<void> createUser(String email, String password) async {
   await auth.createUserWithEmailAndPassword(email: email, password: password);

   }
/*   Future<void> addUser(UserModel user,) async{
     await collectionReference.collection('students').add(user.toMap());

   }*/
   Future<StudentModel?> getUser(String uid)async {
     QuerySnapshot userSnapShot = await collectionReference.collection('students').where('id' ,isEqualTo: uid).get();
     if(userSnapShot.docs.isNotEmpty){
       return StudentModel.fromDocumentSnapShot(userSnapShot.docs.first);
     }

   }

}
