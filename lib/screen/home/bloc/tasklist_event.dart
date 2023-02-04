part of 'tasklist_bloc.dart';

@immutable
<<<<<<< HEAD
abstract class TaskListEvenet {}

class TaskListStarted extends TaskListEvenet {}

class TaskListSearch extends TaskListEvenet {
  final String searchterm;
  TaskListSearch({required this.searchterm});
}

class TaskListDeleteAll extends TaskListEvenet {}
=======
abstract class TaskListEvent {}

class TaskListStart extends TaskListEvent {}

class TaskListSerach extends TaskListEvent {
  final String searchTerm;
  TaskListSerach(this.searchTerm);
}

class TaskListDeleteAll extends TaskListEvent {}
>>>>>>> blocdev_2
