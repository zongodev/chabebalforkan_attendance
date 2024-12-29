import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class CustomDayView extends StatelessWidget {
  const CustomDayView({super.key, required this.dateTime, required this.event});
final DateTime dateTime;
final EventController event ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DayView(
        initialDay: dateTime,
        controller: event,
      ),
    );
  }
}
