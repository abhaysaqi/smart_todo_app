import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              Expanded(flex: 3, child: Container(color: Colors.teal.shade600)),
              Expanded(flex: 7, child: Container(color: Colors.white)),
            ],
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(child: Center(child: SizedBox(height:MediaQuery.of(context).size.height ,width: MediaQuery.of(context).size.width,child: child,))),
        ),
      ],
    );
  }
}
