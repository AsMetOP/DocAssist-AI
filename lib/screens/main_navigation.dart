import 'package:flutter/material.dart';
import 'package:doc_assist/core//theme.dart';
import 'dashboard_screen.dart';
import 'symptom_screen.dart';
import 'document_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<String> _titles = [
    "Dashboard",
    "Symptom Check",
    "Document Vault",
    "History",
    "Settings"
  ];

  final List<Widget> _pages = const [
    DashboardScreen(),
    SymptomScreen(),
    DocumentScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon:
            Icon(Icons.monitor_heart_outlined),
            label: "Symptom",
          ),
          BottomNavigationBarItem(
            icon:
            Icon(Icons.description_outlined),
            label: "Documents",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon:
            Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}