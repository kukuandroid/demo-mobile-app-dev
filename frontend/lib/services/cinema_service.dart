import '../utils/http_service.dart';

class CinemaService {
  static const String _cinemasEndpoint = 'cinemas';

  static Future<List<Map<String, dynamic>>> getAllCinemas() async {
    try {
      final response = await HttpService.get(_cinemasEndpoint);

      if (response is Map && response.containsKey('cinemas')) {
        final cinemasData = response['cinemas'] as List;
        return List<Map<String, dynamic>>.from(cinemasData);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to load cinemas: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getCinemasByCity(String city) async {
    try {
      final response = await HttpService.get('$_cinemasEndpoint/city/$city');

      if (response is Map && response.containsKey('cinemas')) {
        final cinemasData = response['cinemas'] as List;
        return List<Map<String, dynamic>>.from(cinemasData);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to load cinemas for city $city: $e');
    }
  }
}