import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:smart_todo_app/app/services/notification_service.dart';
import 'package:smart_todo_app/app/views/add_edit_todo_screen.dart';
import 'package:smart_todo_app/app/views/home_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/add_edit', page: () => AddEditToDoScreen()),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey.shade300,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade300),
      ),
    );
  }
}
