import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/document_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DoccyApp());
}

class DoccyApp extends StatelessWidget {
  const DoccyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DocumentProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
