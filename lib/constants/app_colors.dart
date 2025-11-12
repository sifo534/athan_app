import 'package:flutter/material.dart';

class AppColors {
  // Primary gradient colors (pink to purple)
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color deepPurple = Color(0xFF673AB7);
  
  // Gradient variations
  static const Color lightPink = Color(0xFFF8BBD9);
  static const Color mediumPink = Color(0xFFEC407A);
  static const Color darkPurple = Color(0xFF4A148C);
  
  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFFBDBDBD);
  
  // Accent colors
  static const Color accent = Color(0xFFFF4081);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  
  // Islamic themed colors
  static const Color islamicGold = Color(0xFFFFD700);
  static const Color islamicGreen = Color(0xFF00695C);
  static const Color qiblaGreen = Color(0xFF2E7D32);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPink, primaryPurple],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightPink, mediumPink],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightPink, Color(0xFFF3E5F5)],
  );
  
  static const LinearGradient mosqueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [deepPurple, darkPurple],
  );
}
