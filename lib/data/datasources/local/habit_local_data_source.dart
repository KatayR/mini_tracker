import '../../models/habit_model.dart';
import '../interfaces/i_crud_data_source.dart';
import 'generic_local_data_source.dart';

abstract class HabitLocalDataSource implements ICrudDataSource<HabitModel> {}

class HabitLocalDataSourceImpl extends GenericLocalDataSourceImpl<HabitModel> implements HabitLocalDataSource {
  // We keep the constructor to enforce the type and pass it to super.
  // The super class will handle all CRUD operations using this box.
  HabitLocalDataSourceImpl(super.habitBox);
}
