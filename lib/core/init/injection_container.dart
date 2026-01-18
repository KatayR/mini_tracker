import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import '../../data/datasources/habit_local_data_source.dart';
import '../../data/datasources/interfaces/i_crud_data_source.dart';
import '../../data/datasources/remote/mock_generic_remote_data_source.dart';
import '../../data/datasources/task_local_data_source.dart';
import '../../data/models/habit_model.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/repositories/i_habit_repository.dart';
import '../../domain/repositories/i_task_repository.dart';
import '../../presentation/controllers/habit_controller.dart';
import '../../presentation/controllers/task_controller.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Task
  sl.registerFactory(() => TaskController(sl()));
  sl.registerLazySingleton<ITaskRepository>(
    () => TaskRepository(
      localDataSource: sl<TaskLocalDataSource>(),
      remoteDataSource: sl(instanceName: 'TaskRemoteDataSource'),
    ),
  );

  sl.registerLazySingleton<TaskLocalDataSource>(() => TaskLocalDataSource(sl()));
  sl.registerLazySingleton<ICrudDataSource<TaskModel>>(() => sl<TaskLocalDataSource>());

  sl.registerLazySingleton<MockGenericRemoteDataSource<TaskModel>>(() => MockGenericRemoteDataSource<TaskModel>());

  // Features - Habit
  sl.registerFactory(() => HabitController(sl()));
  sl.registerLazySingleton<IHabitRepository>(
    () => HabitRepository(
      localDataSource: sl<HabitLocalDataSource>(),
      remoteDataSource: sl<MockGenericRemoteDataSource<HabitModel>>(),
    ),
  );

  sl.registerLazySingleton<HabitLocalDataSource>(() => HabitLocalDataSource(sl()));
  sl.registerLazySingleton<MockGenericRemoteDataSource<HabitModel>>(() => MockGenericRemoteDataSource<HabitModel>());

  // External
  final taskBox = Hive.box<TaskModel>('tasks');
  sl.registerLazySingleton(() => taskBox);

  final habitBox = Hive.box<HabitModel>('habits');
  sl.registerLazySingleton(() => habitBox);
}
