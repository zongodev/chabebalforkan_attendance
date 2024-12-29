import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_pres/controller/auth_controller.dart';
import '../../consts/colors.dart';
import '../../shared/widgets/custom_text_fields.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final auth = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  String? selectedSubClass; // To hold the selected subclass
  List<Map<String, dynamic>> allSubClasses = []; // Store all subclasses here


  @override
  void initState() {
    super.initState();
    fetchAllSubClasses();
  }

  Future<void> fetchAllSubClasses() async {
    allSubClasses = await auth.fetchAllSubClasses();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bglogin1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "إنشاء حساب",
                    style: TextStyle(
                      fontFamily: "Kufam",
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff534940),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'الاسم',
                          sufIcon: Icons.person,
                          controller: auth.firstName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال اسمك';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'اللقب',
                          sufIcon: Icons.person,
                          controller: auth.lastName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال لقبك';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'البريد الإلكتروني',
                          sufIcon: Icons.email,
                          controller: auth.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال بريدك الإلكتروني';
                            } else if (!GetUtils.isEmail(value)) {
                              return 'الرجاء إدخال بريد إلكتروني صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'كلمة المرور',
                          sufIcon: Icons.password,
                          controller: auth.pass,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            } else if (value.length < 6) {
                              return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'اختر الفئة الفرعية', // Select Subclass
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(),
                            ),
                          ),
                          value: selectedSubClass,
                          onChanged: (newValue) {
                            setState(() {
                              selectedSubClass = newValue;
                            });
                          },
                          items: allSubClasses.map((subClassItem) {
                            return DropdownMenuItem<String>(
                              value: subClassItem['classId'],
                              child: Text(subClassItem['className']), // Displaying the document ID
                            );
                          }).toList(),
                          validator: (value) => value == null ? 'الرجاء اختيار فئة فرعية' : null, // Please select a subclass
                        ),
                        const SizedBox(height: 30), // Increased spacing for a cleaner layout
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(29)),
                            backgroundColor: ThemeColors.kPrimaryColor,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Kufam",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              auth.registerUser(selectedSubClass!); // Call createUser method in AuthController
                            }
                          },
                          child: const Text(
                            "إنشاء الحساب", // Create Account
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/*
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_pres/controller/auth_controller.dart';
import '../../consts/colors.dart';
import '../../shared/widgets/custom_text_fields.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final auth = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  String? selectedSubClass; // To hold the selected subclass
  List allSubClasses = []; // Store all subclasses here

  @override
  void initState() {
    super.initState();
    fetchAllSubClasses();
  }

  Future<void> fetchAllSubClasses() async {
    allSubClasses = await auth.fetchAllSubClasses();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bglogin1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "إنشاء حساب",
                    style: TextStyle(
                      fontFamily: "Kufam",
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff534940),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Other fields...

                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'اختر الفئة الفرعية', // Select Subclass
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(),
                            ),
                          ),
                          value: selectedSubClass,
                          onChanged: (newValue) {
                            setState(() {
                              selectedSubClass = newValue;
                            });
                          },
                          items: allSubClasses.map((subClassItem) {
                            return DropdownMenuItem<String>(
                              value: subClassItem,
                              child: Text(subClassItem), // Displaying the document ID
                            );
                          }).toList(),
                          validator: (value) => value == null ? 'الرجاء اختيار فئة فرعية' : null, // Please select a subclass
                        ),

                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(29),
                            ),
                            backgroundColor: ThemeColors.kPrimaryColor,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Kufam",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              auth.registerUser(selectedSubClass!); // Use selected subclass
                            }
                          },
                          child: const Text(
                            "إنشاء الحساب", // Create Account
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
