import 'package:flutter/material.dart';
import 'package:schedule/component/calendar.dart';
import 'package:schedule/component/schedule_card.dart';
import 'package:schedule/component/today_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              onDaySelected: onDaySelected,
              selectedDay: selectedDay,
              focusedDay: focusedDay,
            ),
            const SizedBox(
              height: 8.0,
            ),
            TodayBanner(
              scheduleCount: 3,
              selectedDay: selectedDay,
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: ScheduleCard(
                color: Colors.red,
                content: '프로그래밍 공부',
                startTime: 8,
                endTime: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  onDaySelected(selectedDay, focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}
