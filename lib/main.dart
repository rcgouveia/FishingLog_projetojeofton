import 'package:flutter/material.dart';

void main() {
  runApp(const FishingApp());
}

class FishingApp extends StatelessWidget {
  const FishingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fishing Store",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(), // replace missing HomePage class with a concrete widget
    );
  }
}
