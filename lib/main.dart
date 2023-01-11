import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/data.dart';
import 'package:todolist/edit_screen.dart';

const boxName = 'taskBox';

final Color backGroundColor = Colors.white.withOpacity(0.9);
final Color primaryColor = Color(0xff794CFF);
final Color primaryTextColor = Colors.black.withOpacity(0.7);
final Color secondryTextColor = Colors.white.withOpacity(0.8);

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntitiyAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntitiy>(boxName);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryColor));
  runApp(const MyApp());
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

class HomeScreen extends StatelessWidget {
  final Box<TaskEntitiy> box = Hive.box(boxName);
  final TaskEntitiy task = TaskEntitiy();
  final TextEditingController textFiledSearchController =
      TextEditingController();
  final ValueNotifier<String> serachKeyWord = ValueNotifier('');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: primaryColor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditScreen(task: TaskEntitiy()),
            ));
          },
          label: Row(
            children: [
              Text(
                'Add New Task',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(CupertinoIcons.add_circled)
            ],
          )),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    primaryColor,
                    Color.fromARGB(255, 82, 39, 176)
                  ])),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'To Do List',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: secondryTextColor),
                        )),
                        Icon(
                          CupertinoIcons.share_solid,
                          size: 24,
                          color: secondryTextColor,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17.5),
                          color: Colors.white),
                      child: TextField(
                        controller: textFiledSearchController,
                        onChanged: (value) {
                          serachKeyWord.value = textFiledSearchController.text;
                        },
                        decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            label: Text('Search Tasks'),
                            prefixIcon: Icon(CupertinoIcons.search)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 0,
            ),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: serachKeyWord,
              builder: (context, value, child) {
                return ValueListenableBuilder<Box<TaskEntitiy>>(
                  valueListenable: box.listenable(),
                  builder: (context, value, child) {
                    final List<TaskEntitiy> items;
                    if (textFiledSearchController.text.isEmpty) {
                      items = box.values.toList();
                    } else {
                      items = box.values
                          .where((task) => task.content
                              .contains(textFiledSearchController.text))
                          .toList();
                    }
                    if (items.isNotEmpty) {
                      return ListView.builder(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 100),
                        itemCount: items.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _FirstRow();
                          } else {
                            final TaskEntitiy newTask = items[index - 1];
                            return _TaskItem(
                              task: newTask,
                            );
                          }
                        },
                      );
                    } else {
                      return EmptyState();
                    }
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_state_picture.png',
            height: 170,
            width: 170,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Your task list is empty',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
          )
        ],
      ),
    );
  }
}

class _TaskItem extends StatefulWidget {
  final TaskEntitiy task;
  _TaskItem({required this.task});

  @override
  State<_TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => EditScreen(task: widget.task),
        ));
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        padding: EdgeInsets.only(right: 8, left: 8),
        height: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.8))]),
        child: Row(
          children: [
            MyCheckBoxTask(
                checkBoxOnTap: () {
                  setState(() {
                    widget.task.isCompleted = !widget.task.isCompleted;
                  });
                },
                isSelected: widget.task.isCompleted),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.task.content,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor),
              ),
            ),
            InkWell(
              child: Icon(
                CupertinoIcons.text_bubble,
                color: Color.fromARGB(255, 28, 0, 212),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FirstRow extends StatelessWidget {
  final Box<TaskEntitiy> box = Hive.box(boxName);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: primaryColor),
                )
              ],
            ),
          ),
          MaterialButton(
            onPressed: () {
              box.clear();
            },
            child: Row(children: [
              Text('Delete All'),
              const SizedBox(
                width: 8,
              ),
              Icon(CupertinoIcons.delete)
            ]),
          )
        ],
      ),
    );
  }
}

class MyCheckBoxTask extends StatelessWidget {
  final bool isSelected;
  final GestureTapCallback checkBoxOnTap;
  MyCheckBoxTask({required this.isSelected, required this.checkBoxOnTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: checkBoxOnTap,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? primaryColor : null),
        child: isSelected
            ? Icon(
                CupertinoIcons.check_mark,
                color: secondryTextColor,
                size: 10,
              )
            : null,
      ),
    );
  }
}
