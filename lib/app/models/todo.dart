import 'package:nylo_framework/nylo_framework.dart';

class Todo extends Model {
  Todo({
    required this.title,
    required this.description,
    this.checked = false,
  });

  String? title;
  String? description;
  bool? checked;

  Todo.fromJson(data) {
    title = data["title"];
    description = data["description"];
    checked = data["checked"];
  }

  @override
  toJson() {
    return {
      "title": title,
      "description": description,
      "checked": checked,
    };
  }
}
