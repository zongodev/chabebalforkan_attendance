import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_pres/routes/app_routes.dart';
import '../../controller/auth_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthController authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // State variable for password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/loginbg.jpg', // Ensure the path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent overlay (optional)
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Login Form
          SafeArea(
            child: SingleChildScrollView( // Prevent overflow
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey, // Form key for validation
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 60), // Top spacing
                      Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffe58d00), // Gold color for the title
                        ),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: authController.emailC,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF7F3ED), // Light beige for text field background
                          hintText: "البريد الإلكتروني",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffc5a66e), // Muted gold for hint text
                          ),
                          labelStyle: TextStyle(color: Color(0xffc5a66e)), // Muted gold for label
                          suffixIcon: Icon(
                            Icons.email,
                            color: Color(0xff006D6F), // Deep teal for icon
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffc5a66e), width: 2), // Muted gold border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff006D6F), width: 2), // Deep teal border on focus
                          ),
                        ),
                        textDirection: TextDirection.rtl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "يرجى إدخال البريد الإلكتروني"; // Please enter email
                          }
                          if (!GetUtils.isEmail(value)) {
                            return "يرجى إدخال بريد إلكتروني صالح"; // Please enter a valid email
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: authController.password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF7F3ED), // Light beige for text field background
                          hintText: "كلمة المرور",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffc5a66e), // Muted gold for hint text
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: Color(0xff006D6F), // Deep teal for visibility icon
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffc5a66e), width: 2), // Muted gold border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff006D6F), width: 2), // Deep teal border on focus
                          ),
                        ),
                        textDirection: TextDirection.rtl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "يرجى إدخال كلمة المرور"; // Please enter password
                          }
                          if (value.length < 6) {
                            return "يجب أن تكون كلمة المرور 6 أحرف على الأقل"; // Password must be at least 6 characters
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
                          backgroundColor: const Color(0xff006D6F), // Deep teal for button background
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Kufam",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.signIn();
                          }
                        },
                        child: Text(
                          "تسجيل الدخول",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.register); // Navigate to Register screen
                        },
                        child: Text(
                          "ليس لديك حساب؟ سجل الآن",
                          style: TextStyle(color: Colors.white,fontSize: 20), // Muted gold for text button
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
