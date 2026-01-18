import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

extension DateTimeFormatting on DateTime {
  String toAppFormat() {
    return DateFormat(AppConstants.dateFormat).format(this);
  }
}
