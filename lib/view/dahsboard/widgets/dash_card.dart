import 'package:flutter/material.dart';

class DashCard extends StatelessWidget {
  const DashCard({
    super.key, required this.text, required this.icon,
  });
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      surfaceTintColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 55,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(text),
        ],
      ),
    );
  }
}
