class Seat {
  final String id;
  final String hallId;
  final String seatNumber;
  final String row;
  final int column;
  final String type;
  final double price;
  final bool isAvailable;

  Seat({
    required this.id,
    required this.hallId,
    required this.seatNumber,
    required this.row,
    required this.column,
    required this.type,
    required this.price,
    required this.isAvailable,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['_id'] ?? json['id'],
      hallId: json['hallId'],
      seatNumber: json['seatNumber'],
      row: json['row'],
      column: json['column'],
      type: json['type'] ?? 'Standard',
      price: (json['price'] ?? 0.0).toDouble(),
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hallId': hallId,
      'seatNumber': seatNumber,
      'row': row,
      'column': column,
      'type': type,
      'price': price,
      'isAvailable': isAvailable,
    };
  }

  Seat copyWith({
    String? id,
    String? hallId,
    String? seatNumber,
    String? row,
    int? column,
    String? type,
    double? price,
    bool? isAvailable,
  }) {
    return Seat(
      id: id ?? this.id,
      hallId: hallId ?? this.hallId,
      seatNumber: seatNumber ?? this.seatNumber,
      row: row ?? this.row,
      column: column ?? this.column,
      type: type ?? this.type,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
