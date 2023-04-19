// private 값들은 불러올 수 없다.
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:schedule/model/category_color.dart';
import 'package:schedule/model/schedule.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// private 값까지 불러 올 수 있다.
part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
//  _$LocalDatabase 'drift_database.g.dart' 생성되면서 drift가 만들어줌
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);
  Future<int> createCategoryColors(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

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
