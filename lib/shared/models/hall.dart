class Hall {
  final String id;
  final String name;
  final String cinemaId;
  final int totalSeats;
  final List<String> seatLayout;
  final String screenType;
  final String soundSystem;

  Hall({
    required this.id,
    required this.name,
    required this.cinemaId,
    required this.totalSeats,
    required this.seatLayout,
    required this.screenType,
    required this.soundSystem,
  });

  factory Hall.fromJson(Map<String, dynamic> json) {
    return Hall(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      cinemaId: json['cinemaId'],
      totalSeats: json['totalSeats'],
      seatLayout: List<String>.from(json['seatLayout'] ?? []),
      screenType: json['screenType'] ?? 'Standard',
      soundSystem: json['soundSystem'] ?? 'Dolby Digital',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cinemaId': cinemaId,
      'totalSeats': totalSeats,
      'seatLayout': seatLayout,
      'screenType': screenType,
      'soundSystem': soundSystem,
    };
  }
}
