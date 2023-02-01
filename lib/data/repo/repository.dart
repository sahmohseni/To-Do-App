import 'package:flutter/cupertino.dart';
import 'package:todolist/data/source/data_source.dart';

class Repository<T> with ChangeNotifier implements DataSource<T> {
  final DataSource<T> localDataSource;
  Repository({required this.localDataSource});

  @override
  Future<T> createOrUpdate(T data) async {
    final T result = await localDataSource.createOrUpdate(data);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete(T data) async {
    localDataSource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
    localDataSource.deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll(String searchKeyword) {
    return localDataSource.getAll(searchKeyword);
  }
}
