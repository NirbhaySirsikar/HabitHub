// ignore_for_file: public_member_api_docs, sort_constructors_first
class Habit {
  String id;
  String today;
  String startDate;
  List<dynamic> currentHabitList;
  List<int> percentSummary;
  Habit({
    required this.id,
    required this.today,
    required this.startDate,
    required this.currentHabitList,
    required this.percentSummary,
  });
}
