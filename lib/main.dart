import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schedule/database/drift_database.dart';
import 'package:schedule/screen/home_screen.dart';

const DEFAULT_COLORS = [
  // 빨강
  'F44336',
  // 주황
  'FF9800'
      // 노랑
      'FFEB3B'
      // 초록
      'FCAF50'
      // 파랑
      '2196F3'
      // 남
      '3F51B5'
      // 보라
      '9C27B0'
];

void main() async {
  // 플러터 프레임 워크가 준비되는지 확인 해줘야 한다.
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  final colors = await database.getCategoryColors();
  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColors(
        CategoryColorsCompanion(
          hexCode: Value(hexCode),
        ),
      );
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: const HomeScreen(),
    );
  }
}
