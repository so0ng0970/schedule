// private 값들은 불러올 수 없다.
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:schedule/model/category_color.dart';
import 'package:schedule/model/schedule.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:schedule/model/schedule_with_color.dart';
// private 값까지 불러 올 수 있다.
part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
//  _$LocalDatabase 'drift_database.g.dart' 생성되면서 drift가 만들어준다
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<Schedule> getScheduleById(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);
  Future<int> createCategoryColors(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  // 삭제 쿼리
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();
  // 업데이트 쿼리
  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

  // 업데이트 된 값을 계속 받을 수 있음
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    // 정석방법
    final query = select(schedules).join([
      innerJoin(
        categoryColors,
        categoryColors.id.equalsExp(schedules.colorID),
      )
    ]);
    query.where(schedules.date.equals(date));
    query.orderBy([
      // asc - 오름차순 , desc - 내림차순
      OrderingTerm.asc(schedules.startTime)
    ]);
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ScheduleWithColor(
                  categoryColor: row.readTable(categoryColors),
                  schedule: row.readTable(schedules),
                ),
              )
              .toList(),
        );

    // int num = 3;
    // // string '3'
    // final resp = num.toString();
    // // int 3 ,.. -  toString 대상이된 것을 리턴한다
    // final resp2 = num..toString();

    // 정석방법이랑 같음
    // return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  // 테이블 상태 버전
  @override
  int get schemaVersion => 1;
}

// 어떤 위치에 지정한 파일로 데이터 베이스 만듬
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(
      p.join(dbFolder.path, 'db.sqlite'),
    );
    return NativeDatabase(file);
  });
}
