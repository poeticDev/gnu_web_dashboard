enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];

/// 📌 **한국어 요일(String) → Weekday 변환**
// int getWeekdayNumber(Weekday day) => day.index + 1;
Weekday getWeekDayFromKr(String krName) {
  for (int i = 0; i < weekdays.length; i++) {
    if (krName.contains(weekdays[i])) {
      return Weekday.values[i];
    }
  }
  return Weekday.sunday;
}

String getWeekdayInKR(Weekday weekday) => weekdays[weekday.index];
