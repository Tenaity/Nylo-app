import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/todo_daily.dart';
import 'package:nylo_framework/nylo_framework.dart';

class TodoDailyList extends StatefulWidget {
  final List<TodoDaily> todos;
  final DateTime selectedDay;
  static String state = "todo_list";

  const TodoDailyList({
    required this.selectedDay,
    required this.todos,
    super.key,
  });

  @override
  _TodoDailyListState createState() => _TodoDailyListState();
}

class _TodoDailyListState extends NyState<TodoDailyList> {
  late List<TodoDaily> todoDailyList = [];

  @override
  void initState() {
    super.initState();
    _updateTodoList();
  }

  @override
  void didUpdateWidget(covariant TodoDailyList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDay != oldWidget.selectedDay ||
        widget.todos != oldWidget.todos) {
      _updateTodoList();
    }
  }

  void _updateTodoList() {
    DateTime normalizedDay = DateTime(widget.selectedDay.year,
        widget.selectedDay.month, widget.selectedDay.day);

    todoDailyList = widget.todos
        .where((todo) => isSameDay(todo.date, normalizedDay))
        .toList();

    setState(() {});
  }

  bool isSameDay(DateTime? day1, DateTime? day2) {
    if (day1 == null || day2 == null) return false;
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  @override
  Widget build(BuildContext context) {
    if (todoDailyList.isEmpty) {
      return Center(child: Text("No Todos for this day."));
    }
    return ListView(
      shrinkWrap: true,
      children: todoDailyList.map(
        (TodoDaily todo) {
          return ListTile(
            title: Text("Todo today: ${todo.today}"),
            subtitle: Text("Todo yesterday: ${todo.yesterday}"),
          );
        },
      ).toList(),
    );
  }
}
