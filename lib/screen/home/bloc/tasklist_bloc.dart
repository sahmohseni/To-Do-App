import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';

part 'tasklist_event.dart';
part 'tasklist_state.dart';

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
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
