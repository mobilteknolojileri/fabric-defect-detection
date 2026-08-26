import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detection_screen.dart';

void main() {
  runApp(const FabricInspectorApp());
}

class FabricInspectorApp extends StatelessWidget {
  const FabricInspectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fabric Inspector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detection': (context) => const DetectionScreen(),
      },
    );
  }
}
