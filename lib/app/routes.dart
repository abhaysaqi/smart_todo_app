import 'package:go_router/go_router.dart';
import 'package:smart_todo_app/app/views/home_screen.dart';

class Routes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [GoRoute(path: '/', builder: (context, state) => HomeScreen())],
  );
}
