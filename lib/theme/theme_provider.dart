import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dark_mode.dart';
import 'light_mode.dart';


final isDarkProvider = StateProvider<bool>((ref) {
  return false;
});


final themeProvider = StateProvider<ThemeData>((ref) {
  final isDark = ref.watch(isDarkProvider);

  return isDark ? darkMode : lightMode;
});
//
//
// class ThemeProvider with ChangeNotifier {
//   ThemeData _themeData = lightMode;
//
//   ThemeData get themeData => _themeData;
//
//   bool get isDarkMode => _themeData == darkMode;
//
//   set themeData(ThemeData themeData) {
//     _themeData = themeData;
//     notifyListeners();
//   }
//
//   void toggleTheme() {
//     if (_themeData == lightMode) {
//       themeData = darkMode;
//     } else {
//       themeData = lightMode;
//     }
//   }
// }
