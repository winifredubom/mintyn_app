import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(  // required for Riverpod
      child: MintynApp(),
    ),
  );
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
