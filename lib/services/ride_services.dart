import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RideService {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? "";

  Future<List<dynamic>> fetchUpcomingRides(String type) async {
    final url = Uri.parse('$baseUrl/api/rides/upcoming/type/$type');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load rides');
    }
  }
}
