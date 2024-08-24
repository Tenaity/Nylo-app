import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/todo_daily.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/resources/widgets/todo_daily_list_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyReportPage extends NyStatefulWidget {
  static const path = '/daily-report';

  DailyReportPage({super.key})
      : super(path, child: () => _DailyReportPageState());
}

class _DailyReportPageState extends NyState<DailyReportPage> {
  final _textFieldReportTodayController = TextEditingController();
  final _textFieldReportYesterdayController = TextEditingController();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime _today = DateTime.now();

  ValueNotifier<DateTime?> _selectedDayNotifier =
      ValueNotifier<DateTime?>(null);
  ValueNotifier<List<TodoDaily>> _todosForSelectedDayNotifier =
      ValueNotifier<List<TodoDaily>>([]);

  Map<DateTime, List<TodoDaily>> listTodoDaily = {};
  int _userPoints = 0;
  DateTime? _lastReportedDate;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedDayNotifier.value = _selectedDay;
    _loadUserPoints();
    _loadTodosFromStorage();
    _loadLastReportedDate();
  }

  Future<void> _loadUserPoints() async {
    _userPoints = await NyStorage.read<int>(StorageKey.points) ?? 0;
  }

  Future<void> _saveUserPoints() async {
    await NyStorage.store(StorageKey.points, _userPoints);
  }

  Future<void> _loadTodosFromStorage() async {
    List<TodoDaily> todos =
        await NyStorage.readCollection(StorageKey.newTodoDailyList);

    listTodoDaily.clear();
    for (var todo in todos) {
      DateTime normalizedDay = _normalizeDate(todo.date);
      listTodoDaily.update(
        normalizedDay,
        (existing) => [...existing, todo],
        ifAbsent: () => [todo],
      );
    }

    _updateTodosForSelectedDay();
  }

  Future<void> _loadLastReportedDate() async {
    _lastReportedDate =
        await NyStorage.read<DateTime>(StorageKey.lastReportedDate);
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = _normalizeDate(selectedDay);
        _selectedDayNotifier.value = _selectedDay;

        _updateTodosForSelectedDay();
      });
    }
  }

  void _updateTodosForSelectedDay() {
    final todos = listTodoDaily[_normalizeDate(_selectedDay!)] ?? [];
    _todosForSelectedDayNotifier.value = todos;
  }

  Future<void> _handleDailyReport() async {
    var results = await _showTextInputDialog(context);
    if (results != null) {
      DateTime selectedDate = _selectedDay!;

      if (_lastReportedDate != null &&
          !isSameDay(
              selectedDate.subtract(Duration(days: 1)), _lastReportedDate!)) {
        _userPoints -= 1;
        await _saveUserPoints();
      }

      _lastReportedDate = selectedDate;
      await NyStorage.store(StorageKey.lastReportedDate, _lastReportedDate);

      bool alreadyReported =
          listTodoDaily.containsKey(_normalizeDate(_selectedDay!));

      if (!alreadyReported) {
        _userPoints += 1;
        await _saveUserPoints();
      }

      var newTodo = TodoDaily(
        today: results[0],
        yesterday: results[1],
        date: _selectedDay!,
      );

      listTodoDaily[_selectedDay!] = [
        ...(listTodoDaily[_selectedDay!] ?? []),
        newTodo
      ];

      await newTodo.saveToCollection(StorageKey.newTodoDailyList);

      _updateTodosForSelectedDay();

      _textFieldReportYesterdayController.clear();
      _textFieldReportTodayController.clear();

      setState(() {});
    }
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Report"),
        leading: Center(
          child: Text("Points: $_userPoints"),
        ),
        leadingWidth: 100,
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: () async {
          if (!isSameDay(_selectedDay, _today)) {
            _showDialog(context);
          } else {
            await _handleDailyReport();
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: TableCalendar(
                daysOfWeekHeight: 20,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                availableGestures: AvailableGestures.all,
                locale: "en_US",
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                rowHeight: 50,
                focusedDay: _focusedDay,
                firstDay: DateTime(2020, 10, 10),
                lastDay: DateTime(2030, 10, 10),
                onDaySelected: _onDaySelected,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                eventLoader: (day) {
                  return _getTodosForDay(_normalizeDate(day));
                },
              ),
            ),
            Text("Todo for ${_selectedDay?.toLocal().toShortDate()}")
                .fontWeightBold(),
            Expanded(
              child: ValueListenableBuilder<List<TodoDaily>>(
                valueListenable: _todosForSelectedDayNotifier,
                builder: (context, todos, _) {
                  if (todos.isEmpty) {
                    return Center(child: Text("No Todos for this day."));
                  }
                  return TodoDailyList(
                    todos: todos,
                    selectedDay: _selectedDay!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TodoDaily> _getTodosForDay(DateTime day) {
    return listTodoDaily[_normalizeDate(day)] ?? [];
  }

  Future<List<String>?> _showTextInputDialog(BuildContext context) async {
    return showDialog<List<String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('What do you plan to do today?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NyTextField.compact(
                controller: _textFieldReportTodayController,
                hintText: "Today's Todo",
                validationRules: "not_empty|max:100",
              ),
              NyTextField.compact(
                controller: _textFieldReportYesterdayController,
                hintText: "Yesterday's Todo",
                validationRules: "not_empty|max:100",
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                showToastSuccess(description: "Report created");
                Navigator.pop(
                  context,
                  [
                    _textFieldReportTodayController.text,
                    _textFieldReportYesterdayController.text,
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('What do you plan to do today?'),
          content: Text("You cannot report this day!"),
          actions: [
            ElevatedButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
