import 'package:flutter/material.dart';
import 'package:smart_todo_app/app/widgets/background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SafeArea(child: Center(child: Text("home sCreen"))),
      ),
    );
  }
}
