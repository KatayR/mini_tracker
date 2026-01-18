import '../../models/habit_model.dart';
import '../interfaces/i_crud_data_source.dart';
import 'generic_local_data_source.dart';

abstract class HabitLocalDataSource implements ICrudDataSource<HabitModel> {}

class HabitLocalDataSourceImpl extends GenericLocalDataSourceImpl<HabitModel> implements HabitLocalDataSource {
  HabitLocalDataSourceImpl(super.habitBox);
}
