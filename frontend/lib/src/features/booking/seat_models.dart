class SeatStatus {
  static const available = 'available';
  static const held = 'held';
  static const booked = 'booked';
}

class SeatInfo {
  final String id;
  final String status;
  final String? reservationId;
  SeatInfo({required this.id, required this.status, this.reservationId});
  factory SeatInfo.fromJson(Map<String, dynamic> j) => SeatInfo(
        id: j['id'],
        status: j['status'],
        reservationId: j['reservationId'],
      );
}

class SeatMap {
  final int rows;
  final int cols;
  final int version;
  final Map<String, SeatInfo> seats;
  SeatMap({required this.rows, required this.cols, required this.version, required this.seats});
  factory SeatMap.fromJson(Map<String, dynamic> j) => SeatMap(
        rows: j['layout']['rows'],
        cols: j['layout']['cols'],
        version: j['version'] ?? 0,
        seats: (j['seats'] as Map<String, dynamic>).map((k, v) => MapEntry(k, SeatInfo.fromJson(v))),
      );
}

class Reservation {
  final String id;
  final String showtimeId;
  final String hallId;
  final List<String> seats;
  final String status; // held | booked
  final int? expiresAt;
  Reservation({required this.id, required this.showtimeId, required this.hallId, required this.seats, required this.status, this.expiresAt});
  factory Reservation.fromJson(Map<String, dynamic> j) => Reservation(
        id: j['reservation']['id'] ?? j['id'],
        showtimeId: j['reservation']['showtimeId'] ?? j['showtimeId'],
        hallId: j['reservation']['hallId'] ?? j['hallId'],
        seats: ((j['reservation']?['seats']) ?? j['seats']).cast<String>(),
        status: j['reservation']?['status'] ?? j['status'],
        expiresAt: j['reservation']?['expiresAt'] ?? j['expiresAt'],
      );
}
