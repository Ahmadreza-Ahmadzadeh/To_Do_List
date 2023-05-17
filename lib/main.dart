import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/repository.dart';
import 'package:to_do_list/data/source/hive_task_source.dart';
import 'package:to_do_list/screens/home/home.dart';

const taskBoxName = 'tasks';
const Color primaryColor = Color(0xff794CFF);
const Color primaryVariantColor = Color(0xff5C0AFF);
const secondaryTextColor = Color(0xffAFBED0);
const normalPriority = Color(0xffF09819);
const highPriority = Color(0xff794CFF);
const lowPriority = Color(0xff3BE1F1);
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: primaryVariantColor),
  );
  runApp(
    ChangeNotifierProvider<Repository<TaskEntity>>(
      create: (context) => Repository<TaskEntity>(
        HiveTaskDataSource(
          Hive.box(taskBoxName),
        ),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To_Do_List',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(
            color: secondaryTextColor,
          ),
          iconColor: secondaryTextColor,
          border: InputBorder.none,
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          primaryVariant: primaryVariantColor,
          background: Color(0xffF3F5F8),
          onBackground: primaryTextColor,
          onSurface: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
            const TextTheme(headline6: TextStyle(fontWeight: FontWeight.bold))),
      ),
      home: HomeScreen(),
    );
  }
}
