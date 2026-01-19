import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/core/network/network_info_impl.dart';
import '../../data/datasources/interfaces/i_crud_data_source.dart';
import '../../data/datasources/local/habit_local_data_source.dart';
import '../../data/datasources/local/task_local_data_source.dart';
import '../../data/datasources/remote/mock_generic_remote_data_source.dart';
import '../../data/models/habit_model.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/core/network/network_info.dart';
import '../../domain/repositories/i_habit_repository.dart';
import '../../domain/repositories/i_task_repository.dart';
import '../../presentation/core/constants/app_constants.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // 1. External (Hive Boxes & Connectivity)
  final taskBox = await Hive.openBox<TaskModel>(AppConstants.taskBox);
  final habitBox = await Hive.openBox<HabitModel>(AppConstants.habitBox);
  final connectivity = Connectivity();

  getIt.registerLazySingleton(() => taskBox);
  getIt.registerLazySingleton(() => habitBox);
  getIt.registerLazySingleton(() => connectivity);

  // 2. Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // 3. Data Sources

  // Local Data Sources (Direct Implementation registration is fine since they implement the interface)
  getIt.registerLazySingleton<TaskLocalDataSource>(() => TaskLocalDataSourceImpl(getIt()));
  getIt.registerLazySingleton<HabitLocalDataSource>(() => HabitLocalDataSourceImpl(getIt()));

  // Remote Data Sources (Generic Mock Implementation)
  // We register them by instanceName to differentiate Task vs Habit storage
  getIt.registerLazySingleton<ICrudDataSource<TaskModel>>(
    () => MockGenericRemoteDataSource<TaskModel>(),
    instanceName: 'remoteTask',
  );
  getIt.registerLazySingleton<ICrudDataSource<HabitModel>>(
    () => MockGenericRemoteDataSource<HabitModel>(),
    instanceName: 'remoteHabit',
  );

  // 4. Repositories
  getIt.registerLazySingleton<ITaskRepository>(
    () => TaskRepositoryImpl(
      localDataSource: getIt<TaskLocalDataSource>(), // Implements ICrudDataSource
      remoteDataSource: getIt(instanceName: 'remoteTask'),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<IHabitRepository>(
    () => HabitRepositoryImpl(
      localDataSource: getIt<HabitLocalDataSource>(),
      remoteDataSource: getIt(instanceName: 'remoteHabit'),
      networkInfo: getIt(),
    ),
  );
}
