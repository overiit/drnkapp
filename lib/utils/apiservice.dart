import 'package:drnk/store/stores.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

String domain = "https://cfwapi.drnk.app";

class ApiService {
  static Future<bool> sendTracking(String type) async {
    PreferenceModel preferenceModel = Get.find<PreferenceModel>();
    if (!preferenceModel.trackingEnabled) return false;

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

  static Future<bool> sendFeedback(
      {required String feedbackType,
      required String content,
      String? contact}) async {
    final String endpoint =
        '/api/feedback?type=$feedbackType${contact != null ? '&contact=$contact' : ''}';
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
