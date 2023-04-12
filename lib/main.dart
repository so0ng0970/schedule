import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schedule/screen/home_screen.dart';

void main() async {
  // 플러터 프레임 워크가 준비되는지 확인 해줘야 한다.
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting();

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
