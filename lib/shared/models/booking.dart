class Booking {
  final String id;
  final String userId;
  final String cinemaId;
  final String hallId;
  final String movieTitle;
  final DateTime showTime;
  final List<String> seatIds;
  final List<String> seatNumbers;
  final double totalAmount;
  final String status;
  final DateTime bookingDate;
  final String? paymentId;
  final Map<String, dynamic>? paymentDetails;

  Booking({
    required this.id,
    required this.userId,
    required this.cinemaId,
    required this.hallId,
    required this.movieTitle,
    required this.showTime,
    required this.seatIds,
    required this.seatNumbers,
    required this.totalAmount,
    required this.status,
    required this.bookingDate,
    this.paymentId,
    this.paymentDetails,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      cinemaId: json['cinemaId'],
      hallId: json['hallId'],
      movieTitle: json['movieTitle'],
      showTime: DateTime.parse(json['showTime']),
      seatIds: List<String>.from(json['seatIds'] ?? []),
      seatNumbers: List<String>.from(json['seatNumbers'] ?? []),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      bookingDate: DateTime.parse(
        json['bookingDate'] ?? DateTime.now().toIso8601String(),
      ),
      paymentId: json['paymentId'],
      paymentDetails: json['paymentDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cinemaId': cinemaId,
      'hallId': hallId,
      'movieTitle': movieTitle,
      'showTime': showTime.toIso8601String(),
      'seatIds': seatIds,
      'seatNumbers': seatNumbers,
      'totalAmount': totalAmount,
      'status': status,
      'bookingDate': bookingDate.toIso8601String(),
      'paymentId': paymentId,
      'paymentDetails': paymentDetails,
    };
  }

  Booking copyWith({
    String? id,
    String? userId,
    String? cinemaId,
    String? hallId,
    String? movieTitle,
    DateTime? showTime,
    List<String>? seatIds,
    List<String>? seatNumbers,
    double? totalAmount,
    String? status,
    DateTime? bookingDate,
    String? paymentId,
    Map<String, dynamic>? paymentDetails,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cinemaId: cinemaId ?? this.cinemaId,
      hallId: hallId ?? this.hallId,
      movieTitle: movieTitle ?? this.movieTitle,
      showTime: showTime ?? this.showTime,
      seatIds: seatIds ?? this.seatIds,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      bookingDate: bookingDate ?? this.bookingDate,
      paymentId: paymentId ?? this.paymentId,
      paymentDetails: paymentDetails ?? this.paymentDetails,
    );
  }
}
