import '../../core/constants/app_constants.dart';

/// Provides pure business logic for habit-related calculations.
class HabitLogic {
  /// Calculates the current streak of consecutive days a habit was completed.
  static int calculateStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;

    final normalizedDates = dates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    int streak = 0;

    // Check if done today
    if (normalizedDates.contains(todayNormalized)) {
      streak++;
    }

    // Check backwards from yesterday
    var checkDate = todayNormalized.subtract(AppConstants.oneDay);
    while (normalizedDates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(AppConstants.oneDay);
    }

    return streak;
  }
}
