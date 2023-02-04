import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';
import 'package:todolist/main.dart';
import 'package:todolist/screen/edit/edit_screen.dart';
import 'package:todolist/screen/home/bloc/tasklist_bloc.dart';
import 'package:todolist/widget.dart';

class HomeScreen extends StatelessWidget {
  final Box<TaskEntitiy> box = Hive.box(boxName);
  final TaskEntitiy task = TaskEntitiy();
  final TextEditingController textFiledSearchController =
      TextEditingController();

  HomeScreen({super.key});
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
              const Text(
                'Add New Task',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(CupertinoIcons.add_circled)
            ],
          )),
      body: BlocProvider<TaskListBloc>(
        create: (context) =>
            TaskListBloc(context.read<Repository<TaskEntitiy>>()),
        child: SafeArea(
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
                          onChanged: (value) {
                            context
                                .read<TaskListBloc>()
                                .add(TaskListSerach(value));
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
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
              Expanded(child: Consumer<Repository<TaskEntitiy>>(
                builder: (context, model, child) {
                  context.read<TaskListBloc>().add(TaskListStart());
                  return BlocBuilder<TaskListBloc, TaskListState>(
                    builder: (context, state) {
                      if (state is TaskListSuccess) {
                        return TaskList(items: state.items);
                      } else if (state is TaskListLoading ||
                          state is TaskListInitial) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is TaskListEmpty) {
                        return EmptyState();
                      } else {
                        return throw Exception(TaskListError('error'));
                      }
                    },
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<TaskEntitiy> items;

  @override
  Widget build(BuildContext context) {
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
              context.read<TaskListBloc>().add(TaskListDeleteAll());
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
