import 'package:hive/hive.dart';

import '../../domain/entities/base_entity.dart';
import 'interfaces/i_crud_data_source.dart';

class GenericLocalDataSourceImpl<T extends BaseEntity> implements ICrudDataSource<T> {
  final Box<T> box;

  GenericLocalDataSourceImpl(this.box);

  @override
  Future<List<T>> getAll() async {
    return box.values.toList();
  }

  @override
  Future<void> create(T item) async {
    await box.put(item.id, item);
  }

  @override
  Future<void> update(T item) async {
    await box.put(item.id, item);
  }

  @override
  Future<void> delete(String id) async {
    await box.delete(id);
  }
}
