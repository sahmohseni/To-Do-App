import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';
import 'package:todolist/data/source/hive_task_data_source.dart';

import 'package:todolist/screen/home/home_screen.dart';

const boxName = 'taskBox';

final Color backGroundColor = Colors.white.withOpacity(0.9);
const Color primaryColor = Color(0xff794CFF);
final Color primaryTextColor = Colors.black.withOpacity(0.7);
final Color secondryTextColor = Colors.white.withOpacity(0.8);

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntitiyAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntitiy>(boxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryColor));
  runApp(ChangeNotifierProvider(
      create: (context) => Repository<TaskEntitiy>(
          localDataSource: HiveTaskDataSource(box: Hive.box(boxName))),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: HomeScreen(),
    );
  }
}
