import '/app/events/create_todo_event.dart';
import '/app/models/user.dart';
import '/app/events/login_event.dart';
import '/app/events/logout_event.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Events
|--------------------------------------------------------------------------
| Add your "app/events" here.
| Events can be fired using: event<MyEvent>();
|
| Learn more: https://nylo.dev/docs/5.20.0/events
|-------------------------------------------------------------------------- */

final Map<Type, NyEvent> events = {
  LoginEvent: LoginEvent(),
  LogoutEvent: LogoutEvent(),
  AuthUserEvent: AuthUserEvent(),
  SyncAuthToBackpackEvent: SyncAuthToBackpackEvent<User>(),


  CreateTodoEvent: CreateTodoEvent(),
  };

