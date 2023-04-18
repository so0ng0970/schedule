import 'package:drift/drift.dart';

class Schedules extends Table {
  // PRIMARY KEY .autoIncrement() -자동으로 늘려줌
  IntColumn get id => integer().autoIncrement()();
  // 내용
  TextColumn get content => text()();
  // 일정 날짜
  DateTimeColumn get date => dateTime()();
  // 시작 시간
  IntColumn get startTime => integer()();
  // 끝 시간
  IntColumn get endTime => integer()();
  // Catagory Color Table ID
  IntColumn get colorID => integer()();
  // 생성 날짜  clientDefault(()=>) - 기본값으로 넣어줄 값 ,값 넣어주면 넣어준 값으로 지정됨 
  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now(),
      )();
}
