import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String domain = "https://cfwapi.drnk.app";

class ApiService {
  static Future<bool> sendTracking(String type) async {
    final String endpoint = '/api/track?type=$type';
    try {
      final response = await http.post(
        Uri.parse(domain + endpoint),
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
        Uri.parse(domain + endpoint),
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
