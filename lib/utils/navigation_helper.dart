import 'package:flutter/material.dart';

class NavigationHelper {
  static final NavigationHelper _instance = NavigationHelper._internal();
  factory NavigationHelper() => _instance;
  NavigationHelper._internal();

  Function(int)? _onNavigateToTab;

  void setNavigationCallback(Function(int) callback) {
    _onNavigateToTab = callback;
  }

  void navigateToTab(int index) {
    _onNavigateToTab?.call(index);
  }

  void navigateToQibla() {
    navigateToTab(1); // Qibla is at index 1
  }

  void navigateToHome() {
    navigateToTab(0); // Home is at index 0
  }

  void navigateToTools() {
    navigateToTab(2); // Tools is at index 2
  }

  void navigateToQuran() {
    navigateToTab(4); // Quran is at index 4
  }

  void navigateToSettings() {
    navigateToTab(6); // Settings is at index 6
  }
}
