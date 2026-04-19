import 'package:flutter/foundation.dart';

class AnalyticsService {
  void logEvent(String name, {Map<String, dynamic>? data}) {
    final time = DateTime.now();

    debugPrint("EVENT: $name");
    debugPrint("TIME: $time");

    if (data != null) {
      debugPrint("DATA: $data");
    }

    debugPrint("------------");
  }
}