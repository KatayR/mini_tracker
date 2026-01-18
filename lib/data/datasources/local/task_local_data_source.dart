import '../../models/task_model.dart';
import '../interfaces/i_crud_data_source.dart';
import 'generic_local_data_source.dart';

abstract class TaskLocalDataSource implements ICrudDataSource<TaskModel> {}

class TaskLocalDataSourceImpl extends GenericLocalDataSourceImpl<TaskModel> implements TaskLocalDataSource {
  // We keep the constructor to enforce the type and pass it to super.
  TaskLocalDataSourceImpl(super.taskBox);
}
