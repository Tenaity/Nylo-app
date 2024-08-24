import 'package:flutter_app/app/models/todo_daily.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/resources/widgets/todo_daily_list_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

class CreateTodoEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    String today = event["today"];
    String yesterday = event["yesterday"];
    DateTime selectedDay = event["date"];
    print("Event $today");
    print("Event $yesterday");

    TodoDaily todo = TodoDaily(
      today: today,
      yesterday: yesterday,
      date: selectedDay,
    );

    await todo.saveToCollection(StorageKey.newTodoDailyList);

    updateState(TodoDailyList.state, data: todo);
  }
}
