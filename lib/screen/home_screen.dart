import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:schedule/component/calendar.dart';
import 'package:schedule/component/schedule_bottom_sheet.dart';
import 'package:schedule/component/schedule_card.dart';
import 'package:schedule/component/today_banner.dart';
import 'package:schedule/const/colors.dart';
import 'package:schedule/database/drift_database.dart';
import 'package:schedule/model/schedule_with_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
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
              selectedDay: selectedDay,
            ),
            const SizedBox(
              height: 8.0,
            ),
            _ScheduleList(
              selectedDate: selectedDay,
            )
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
  final DateTime selectedDate;
  const _ScheduleList({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<List<ScheduleWithColor>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('스케쥴이 없습니다'),
                );
              }
              return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 8.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    final scheduleWithColor = snapshot.data![index];
                    return Dismissible(
                      key: ObjectKey(scheduleWithColor.schedule.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction) {
                        GetIt.I<LocalDatabase>()
                            .removeSchedule(scheduleWithColor.schedule.id);
                      },
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) {
                                return ScheduleBottomSheet(
                                  selectedDate: selectedDate,
                                  scheduleId: scheduleWithColor.schedule.id,
                                );
                              });
                        },
                        child: ScheduleCard(
                          color: Color(
                            int.parse(
                                'FF${scheduleWithColor.categoryColor.hexCode}',
                                radix: 16),
                          ),
                          content: scheduleWithColor.schedule.content,
                          startTime: scheduleWithColor.schedule.startTime,
                          endTime: scheduleWithColor.schedule.endTime,
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
