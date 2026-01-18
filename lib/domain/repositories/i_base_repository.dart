import '../entities/base_entity.dart';

abstract class IBaseRepository<T extends BaseEntity> {
  Future<List<T>> fetchAllItems();
  Future<void> create(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
  Future<void> syncRemote();
}
