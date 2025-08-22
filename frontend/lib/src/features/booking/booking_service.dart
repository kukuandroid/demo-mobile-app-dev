import '../../core/network/api_client.dart';
import 'seat_models.dart';

class BookingService {
  final ApiClient api;
  BookingService(this.api);

  Future<SeatMap> fetchSeatMap(String hallId, String showtimeId) async {
    final data = await api.getJson('/api/halls/$hallId/seatmap', query: {'showtimeId': showtimeId});
    return SeatMap.fromJson(data);
    }

  Future<Reservation> holdSeats({required String hallId, required String showtimeId, required List<String> seats}) async {
    final data = await api.postJson('/api/reserve', body: {
      'action': 'hold',
      'hallId': hallId,
      'showtimeId': showtimeId,
      'seats': seats,
    });
    return Reservation.fromJson(data);
  }

  Future<Reservation> confirmReservation({required String reservationId, required String hallId, required String showtimeId, required List<String> seats}) async {
    final data = await api.postJson('/api/reserve', body: {
      'action': 'confirm',
      'reservationId': reservationId,
      'hallId': hallId,
      'showtimeId': showtimeId,
      'seats': seats,
    });
    return Reservation.fromJson(data);
  }

  Future<void> releaseReservation({required String reservationId, required String hallId, required String showtimeId, required List<String> seats}) async {
    await api.postJson('/api/reserve', body: {
      'action': 'release',
      'reservationId': reservationId,
      'hallId': hallId,
      'showtimeId': showtimeId,
      'seats': seats,
    });
  }
}
