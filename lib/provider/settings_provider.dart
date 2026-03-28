import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool saveHistory = true; // ON by default
  bool anonymousMode = false;

  void toggleSaveHistory(bool value) {
    saveHistory = value;
    notifyListeners();
  }

  void toggleAnonymousMode(bool value) {
    anonymousMode = value;

    // Anonymous mode disables history
    if (anonymousMode) {
      saveHistory = false;
    }

    notifyListeners();
  }
}