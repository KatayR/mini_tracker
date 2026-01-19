import '../../domain/core/network/network_info.dart';
import '../../domain/entities/base_entity.dart';
import '../../domain/repositories/i_base_repository.dart';
import '../../presentation/core/utils/logger.dart';
import '../datasources/interfaces/i_crud_data_source.dart';

abstract class BaseRepository<E extends BaseEntity, M extends E> implements IBaseRepository<E> {
  final ICrudDataSource<M> localDataSource;
  final ICrudDataSource<M> remoteDataSource;
  final NetworkInfo networkInfo;
  final String logLabel;

  BaseRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.logLabel,
  });

  M toModel(E entity);

  @override
  Future<List<E>> fetchAllItems() async {
    try {
      return await localDataSource.getAll();
    } catch (e) {
      AppLogger.e("$logLabel Local Load Error", e);
      return [];
    }
  }

  @override
  Future<void> syncRemote() async {
    await _ensureOnline();

    try {
      // 1. Get current states
      final localItems = await localDataSource.getAll();
      final remoteItems = await remoteDataSource.getAll();

      // 2. Push missing local items to remote (Restore remote state for successful interactions)
      for (final localItem in localItems) {
        if (!remoteItems.any((r) => r.id == localItem.id)) {
          // We map to model and create on remote
          await remoteDataSource.create(toModel(localItem));
        }
      }

      // 3. Re-fetch from remote to get the consistent state (including what we just pushed)
      // and update local cache to match.
      final updatedRemoteItems = await remoteDataSource.getAll();
      if (updatedRemoteItems.isNotEmpty) {
        await localDataSource.cacheAll(updatedRemoteItems);
      }
    } catch (e) {
      AppLogger.e("$logLabel Remote Sync Error", e);
      rethrow;
    }
  }

  @override
  Future<void> create(E item) async {
    final model = toModel(item);
    try {
      await _ensureOnline();
      // 1. Remote update (Source of Truth)
      await remoteDataSource.create(model);

      // 2. Local Cache Update
      await localDataSource.create(model);
    } catch (e) {
      AppLogger.e("$logLabel Add Remote Error", e);
      rethrow;
    }
  }

  @override
  Future<void> update(E item) async {
    final model = toModel(item);
    try {
      await _ensureOnline();
      // 1. Remote update
      await remoteDataSource.update(model);

      // 2. Local Cache Update
      await localDataSource.update(model);
    } catch (e) {
      AppLogger.e("$logLabel Update Remote Error", e);
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _ensureOnline();
      // 1. Remote update
      await remoteDataSource.delete(id);

      // 2. Local Cache Update
      await localDataSource.delete(id);
    } catch (e) {
      AppLogger.e("$logLabel Delete Remote Error", e);
      rethrow;
    }
  }

  Future<void> _ensureOnline() async {
    if (!await networkInfo.isConnected) {
      throw Exception("No Internet Connection");
    }
  }
}
