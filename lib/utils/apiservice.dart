import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

bool? isDebug;

String getDomain() {
  if (isDebug == null) {
    isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());
  }
  if (isDebug == false) {
    return 'https://cfwapi.drnk.app';
  } else {
    return 'http://cfwapi-dev.drnk.app';
  }
}

class ApiService {
  static Future<bool> sendTracking(String type) async {
    final String endpoint = '/api/track?type=$type';
    try {
      final response = await http.post(
        Uri.parse(getDomain() + endpoint),
        headers: {
          "Content-Type": "application/json",
        },
      );
      return response.statusCode == 200;
    } catch (err) {}
    return false;
  }

  static Future<bool> sendFeedback(String feedbackType, String content) async {
    final String endpoint = '/api/feedback?type=$feedbackType';
    try {
      final response = await http.post(
        Uri.parse(getDomain() + endpoint),
        headers: {
          "Content-Type": "text/plain",
        },
        body: content,
      );
      return response.statusCode == 200;
    } catch (err) {}
    return false;
  }
}
