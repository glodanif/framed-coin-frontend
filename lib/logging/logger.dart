import 'package:flutter/foundation.dart';

class Logger {

  static void error(String message) {
    if (!kReleaseMode) {
      debugPrint("🚫 $message");
      debugPrint("----------------------------------------------------");
    }
  }

  static void event(String message) {
    if (!kReleaseMode) {
      debugPrint("🔖 $message");
      debugPrint("----------------------------------------------------");
    }
  }

  static void bloc(String message) {
    if (!kReleaseMode) {
      debugPrint("📦 $message");
      debugPrint("----------------------------------------------------");
    }
  }

  static void watch(String message) {
    if (!kReleaseMode) {
      debugPrint("👉 $message");
      debugPrint("----------------------------------------------------");
    }
  }
}
