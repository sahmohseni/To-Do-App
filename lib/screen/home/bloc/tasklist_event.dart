part of 'tasklist_bloc.dart';

@immutable
abstract class TaskListEvenet {}

class TaskListStarted extends TaskListEvenet {}

class TaskListSearch extends TaskListEvenet {
  final String searchterm;
  TaskListSearch({required this.searchterm});
}

class TaskListDeleteAll extends TaskListEvenet {}
