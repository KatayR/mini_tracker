import '../../models/task_model.dart';
import '../interfaces/i_crud_data_source.dart';
import 'generic_local_data_source.dart';

abstract class TaskLocalDataSource implements ICrudDataSource<TaskModel> {}

class TaskLocalDataSourceImpl extends GenericLocalDataSourceImpl<TaskModel> implements TaskLocalDataSource {
  TaskLocalDataSourceImpl(super.taskBox);
}
