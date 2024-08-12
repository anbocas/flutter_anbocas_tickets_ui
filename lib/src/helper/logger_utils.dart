import 'package:flutter/foundation.dart';

mixin LoggerUtils {
  void info(String message) {
    if (kDebugMode) {
      print('\x1B[34m ====[ INFO ]=====>>  $message \x1B[0m');
    }
  }

  void error(String message) {
    if (kDebugMode) {
      print('\x1B[31m ====[ ERROR ]=====>>  $message \x1B[0m');
    }
  }

  void warning(String message) {
    if (kDebugMode) {
      print('\x1B[33m ====[ WARNING ]=====>>  $message \x1B[0m');
    }
  }

  void stacktrace(Exception exception) {
    if (kDebugMode) {
      print('\x1B[33m ====[ Stacktrace ]=====>>  ${exception} \x1B[0m');
    }
  }
}
