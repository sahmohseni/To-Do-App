import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';

part 'tasklist_event.dart';
part 'tasklist_state.dart';

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
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
