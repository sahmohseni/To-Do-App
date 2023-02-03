part of 'tasklist_bloc.dart';

@immutable
abstract class TaskListState {}

class TaskListInitilal extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListSuccess extends TaskListState {
  final List<TaskEntitiy> items;
  TaskListSuccess({required this.items});
}

class TaskListEmpty extends TaskListState {}

class TaskListError extends TaskListState {
  final String errorMessage;
  TaskListError({required this.errorMessage});
}
