import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  final String label;
  final IconData sufIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  bool obscureText;
   CustomTextField({
    super.key,
    required this.label,
    required this.sufIcon, required this.controller, this.validator,  this.obscureText=false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintTextDirection: TextDirection.rtl,
        hintText: label,
        hintStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff6d5f56)),
        suffixIcon: Icon(sufIcon, color: const Color(0xff6d5f56)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color:  Color(0xff6d5f56), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff6d5f56), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
