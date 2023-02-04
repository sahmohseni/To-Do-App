part of 'tasklist_bloc.dart';

@immutable
abstract class TaskListState {}

class TaskListInitial extends TaskListState {}

class TaskListSuccess extends TaskListState {
  final List<TaskEntitiy> items;
  TaskListSuccess(this.items);
}

class TaskListLoading extends TaskListState {}

class TaskListError extends TaskListState {
  final String errorMessage;
  TaskListError(this.errorMessage);
}

class TaskListEmpty extends TaskListState {}
