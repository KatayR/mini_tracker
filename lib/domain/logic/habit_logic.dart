import '../core/logic_constants.dart';

/// Provides pure business logic for habit-related calculations.
///
/// This class contains static utility methods that operate on habit data
/// without any side effects or dependencies on external state.
/// All methods are pure functions suitable for unit testing.
class HabitLogic {
  /// Calculates the current streak of consecutive days a habit was completed.
  ///
  /// The algorithm works as follows:
  /// 1. Normalizes all dates to midnight (removes time component) to ensure
  ///    accurate day-by-day comparison.
  /// 2. Checks if the habit was completed today - if yes, starts streak at 1.
  /// 3. Iterates backwards from yesterday, counting consecutive days where
  ///    the habit was completed.
  /// 4. Stops counting when a gap (missed day) is found.
  ///
  /// **Example:**
  /// - If today is Jan 18 and completion dates are [Jan 18, Jan 17, Jan 16, Jan 14],
  ///   the streak is 3 (Jan 18, 17, 16). Jan 15 is missing, breaking the chain.
  ///
  /// **Edge Cases:**
  /// - Returns 0 if [dates] is empty.
  /// - If the habit was not completed today but was completed yesterday,
  ///   the streak starts counting from yesterday.
  ///
  /// [dates] - List of DateTime objects representing when the habit was completed.
  ///           Does not need to be sorted; duplicates are handled via Set conversion.
  ///
  /// Returns the number of consecutive days the habit has been maintained,
  /// starting from today or yesterday and counting backwards.
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
    var checkDate = todayNormalized.subtract(LogicConstants.oneDay);
    while (normalizedDates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(LogicConstants.oneDay);
    }

    return streak;
  }
}
