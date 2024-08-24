import 'package:nylo_framework/nylo_framework.dart';

class TodoDaily extends Model {
  TodoDaily({
    required this.yesterday,
    required this.today,
    required this.date,
  });

  String yesterday;
  String today;
  DateTime date;

  // Fixed fromJson constructor
  TodoDaily.fromJson(Map<String, dynamic> data)
      : yesterday = data["yesterday"] ?? '', // Provide a default value if null
        today = data["today"] ?? '', // Provide a default value if null
        date = DateTime.tryParse(data["date"] ?? '') ??
            DateTime.now(); // Handle null and parse errors

  @override
  Map<String, dynamic> toJson() {
    return {
      "yesterday": yesterday,
      "today": today,
      'date': date.toIso8601String(),
    };
  }
}
