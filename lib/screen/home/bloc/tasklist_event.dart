part of 'tasklist_bloc.dart';

@immutable
abstract class TaskListEvent {}

class TaskListStart extends TaskListEvent {}

class TaskListSerach extends TaskListEvent {
  final String searchTerm;
  TaskListSerach(this.searchTerm);
}

class TaskListDeleteAll extends TaskListEvent {}
