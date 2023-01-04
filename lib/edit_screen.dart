import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todolist/data.dart';
import 'package:todolist/main.dart';

class EditScreen extends StatefulWidget {
  final TaskEntitiy task;
  EditScreen({required this.task});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TextEditingController _taskContentController =
      TextEditingController(text: widget.task.content);

  final Box<TaskEntitiy> box = Hive.box(boxName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: primaryColor,
          onPressed: () {
            widget.task.content = _taskContentController.text;
            widget.task.isCompleted = false;
            widget.task.priority = Priority.normal;
            if (widget.task.isInBox) {
              widget.task.save();
            } else {
              box.add(widget.task);
            }
            Navigator.of(context).pop();
          },
          label: Row(
            children: [
              Text(
                'Save Changes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                CupertinoIcons.check_mark,
                color: secondryTextColor,
                size: 17,
              )
            ],
          )),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primaryTextColor,
        title: Text(
          'Edit Task',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _taskContentController,
              decoration:
                  InputDecoration(label: Text('Add a task for today ...')),
            )
          ],
        ),
      ),
    );
  }
}
