import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/data.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: primaryVariantColor),
  );
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryVariantColor = Color(0xff5C0AFF);
final secondaryTextColor = const Color(0xffAFBED0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryTextColor = const Color(0xff1D2830);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To_Do_List',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: secondaryTextColor,
          ),
          iconColor: secondaryTextColor,
          border: InputBorder.none,
        ),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          primaryVariant: primaryVariantColor,
          background: const Color(0xffF3F5F8),
          onBackground: primaryTextColor,
          onSurface: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
            TextTheme(headline6: TextStyle(fontWeight: FontWeight.bold))),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(taskBoxName);
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(),
            ),
          );
        },
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Add New Task'),
            Icon(
              CupertinoIcons.add,
              size: 20,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryVariant
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Do List',
                          style: themeData.textTheme.headline6!
                              .apply(color: Colors.white),
                        ),
                        Icon(CupertinoIcons.share,
                            color: themeData.colorScheme.onPrimary),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: themeData.colorScheme.onPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search tasks ...'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<TaskEntity>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: box.values.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Today',
                                    style: themeData.textTheme.headline6!
                                        .apply(fontSizeFactor: 0.9),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 70,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(1.5)),
                                  )
                                ],
                              ),
                              MaterialButton(
                                color: const Color(0xffEAEFF5),
                                elevation: 0,
                                textColor: secondaryTextColor,
                                onPressed: () {},
                                child: const Row(
                                  children: [
                                    Text('Delet All'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      CupertinoIcons.delete_solid,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        final TaskEntity task = box.values.toList()[index - 1];
                        return TaskItem(task: task);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          widget.task.isComplited = !widget.task.isComplited;
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeData.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            MyCheckBox(value: widget.task.isComplited),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 24,
                    decoration: widget.task.isComplited
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;

  const MyCheckBox({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: value ? null : Border.all(color: secondaryTextColor, width: 2),
        color: value ? primaryColor : null,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 16,
            )
          : null,
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  EditTaskScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final task = TaskEntity();
          task.name = _controller.text;
          task.priority = Priority.low;
          if (task.isInBox) {
            task.save();
          } else {
            final Box<TaskEntity> box = Hive.box(taskBoxName);
            box.add(task);
          }
          Navigator.of(context).pop();
        },
        label: const Text('Save changes'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              label: Text('Add Task for today ...'),
            ),
          ),
        ],
      ),
    );
  }
}
