import 'package:flutter/material.dart';
import 'package:schedule/component/calendar.dart';
import 'package:schedule/component/schedule_bottom_sheet.dart';
import 'package:schedule/component/schedule_card.dart';
import 'package:schedule/component/today_banner.dart';
import 'package:schedule/const/colors.dart';

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
      floatingActionButton: renderFloatingActionButton(),
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
            const _ScheduleList()
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return ScheduleBottomSheet(
                selectedDate: selectedDay,
              );
            });
      },
      backgroundColor: PRIMARY_COLOR,
      child: const Icon(Icons.add),
    );
  }

  onDaySelected(selectedDay, focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 8.0,
              );
            },
            itemBuilder: (context, index) {
              return ScheduleCard(
                color: Colors.red,
                content: '프로그래밍 공부 $index',
                startTime: 8,
                endTime: 12,
              );
            }),
      ),
    );
  }
}
