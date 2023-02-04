import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';

part 'tasklist_event.dart';
part 'tasklist_state.dart';

<<<<<<< HEAD
class TasklistBloc extends Bloc<TaskListEvenet, TaskListState> {
  final Repository<TaskEntitiy> repository;
  TasklistBloc(this.repository) : super(TaskListInitilal()) {
    on<TaskListEvenet>((event, emit) async {
      if (event is TaskListStarted || event is TaskListSearch) {
        final String searchTerm;
        emit(TaskListLoading());
        if (event is TaskListSearch) {
          searchTerm = event.searchterm;
        } else {
          searchTerm = '';
        }
        try {
          final items = await repository.getAll(searchTerm);
          if (items.isNotEmpty) {
            emit(TaskListSuccess(items: items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (error) {
          emit(TaskListError(errorMessage: 'state is invalid'));
=======
class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntitiy> repository;

  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStart || event is TaskListSerach) {
        emit(TaskListInitial());
        final String searchTerm;
        if (event is TaskListSerach) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = "";
        }
        try {
          final itemList = await repository.getAll(searchTerm);
          if (itemList.isNotEmpty) {
            emit(TaskListSuccess(itemList));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError('error'));
>>>>>>> blocdev_2
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
