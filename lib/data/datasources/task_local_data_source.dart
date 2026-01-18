import '../models/task_model.dart';
import 'generic_local_data_source.dart';

class TaskLocalDataSource extends GenericLocalDataSourceImpl<TaskModel> {
  TaskLocalDataSource(super.box);
}
