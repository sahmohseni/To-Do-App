import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/source/data_source.dart';

class HiveTaskDataSource implements DataSource<TaskEntitiy> {
  final Box<TaskEntitiy> box;
  HiveTaskDataSource({required this.box});

  @override
  Future<TaskEntitiy> createOrUpdate(TaskEntitiy data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(TaskEntitiy data) {
    return box.delete(data);
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    return box.delete(id);
  }

  @override
  Future<TaskEntitiy> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<TaskEntitiy>> getAll(String searchKeyword) async {
    if (searchKeyword.isEmpty) {
      return box.values.toList();
    } else {
      return box.values
          .where((element) => element.content.contains(searchKeyword))
          .toList();
    }
  }
}
