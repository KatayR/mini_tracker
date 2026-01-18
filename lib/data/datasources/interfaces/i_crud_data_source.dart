abstract class ICrudDataSource<T> {
  Future<List<T>> getAll();
  Future<T> create(T item);
  Future<T> update(T item);
  Future<void> delete(String id);
  Future<void> cacheAll(List<T> items);
}
