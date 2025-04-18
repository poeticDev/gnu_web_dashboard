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

Weekday getWeekdayFromDateTime(DateTime dateTime) {
  final int today = dateTime.weekday;
  return Weekday.values[today - 1]; // DateTime은 1(월) ~ 7(일), Weekday는 0 index 기반
}
