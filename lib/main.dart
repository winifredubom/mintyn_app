import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MintynApp());
}

class MintynApp extends StatelessWidget {
  const MintynApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mintyn App',
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
