import 'dart:convert';
import 'package:http/http.dart' as http;

class RideService {
  final String baseUrl = 'http://localhost:8080/api/rides';

  Future<List<dynamic>> fetchUpcomingRides(String type) async {
    final url = Uri.parse('$baseUrl/upcoming/type/$type');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load rides');
    }
  }
}
