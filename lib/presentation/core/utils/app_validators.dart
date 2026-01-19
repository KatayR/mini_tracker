import '../constants/app_strings.dart';

class AppValidators {
  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? AppStrings.fieldRequired;
    }
    return null;
  }
}
