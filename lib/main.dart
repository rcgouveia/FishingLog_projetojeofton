import 'package:flutter/material.dart';
import 'package:myapp/core/db/HiveConfig.dart';
import 'package:myapp/pages/home/HomePage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FishingLog IA Teste',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(), // AQUI É O IMPORTANTE
    );
  }
}
