import '../../core/network/api_client.dart';
import 'booking_models.dart';

class BookingSelectionService {
  final ApiClient api;
  BookingSelectionService(this.api);

  Future<List<Location>> fetchLocations() async {
    final data = await api.getJson('/api/locations');
    return (data as List).map((e) => Location.fromJson(e)).toList();
  }

  Future<List<Cinema>> fetchCinemas({String? locationId}) async {
    final data = await api.getJson('/api/cinemas', 
        query: locationId != null ? {'locationId': locationId} : null);
    return (data as List).map((e) => Cinema.fromJson(e)).toList();
  }

  Future<List<ShowtimeSlot>> fetchShowtimes({
    required String movieId,
    String? cinemaId,
    String? date,
  }) async {
    final query = <String, String>{'movieId': movieId};
    if (cinemaId != null) query['cinemaId'] = cinemaId;
    if (date != null) query['date'] = date;
    
    final data = await api.getJson('/api/showtimes', query: query);
    return (data as List).map((e) => ShowtimeSlot.fromJson(e)).toList();
  }

  Future<List<String>> getAvailableDates({
    required String movieId,
    String? cinemaId,
  }) async {
    final showtimes = await fetchShowtimes(movieId: movieId, cinemaId: cinemaId);
    final dates = showtimes.map((s) => s.date).toSet().toList();
    dates.sort();
    return dates;
  }
}
