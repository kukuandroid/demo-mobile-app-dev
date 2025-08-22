class Location {
  final String id;
  final String name;
  final String state;
  final String country;

  Location({
    required this.id,
    required this.name,
    required this.state,
    required this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json['id'],
        name: json['name'],
        state: json['state'],
        country: json['country'],
      );
}

class Cinema {
  final String id;
  final String name;
  final String locationId;
  final String address;
  final List<String> halls;

  Cinema({
    required this.id,
    required this.name,
    required this.locationId,
    required this.address,
    required this.halls,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) => Cinema(
        id: json['id'],
        name: json['name'],
        locationId: json['locationId'],
        address: json['address'],
        halls: (json['halls'] as List).cast<String>(),
      );
}

class ShowtimeSlot {
  final String id;
  final String movieId;
  final String cinemaId;
  final String hallId;
  final String date;
  final String startTime;
  final double price;

  ShowtimeSlot({
    required this.id,
    required this.movieId,
    required this.cinemaId,
    required this.hallId,
    required this.date,
    required this.startTime,
    required this.price,
  });

  factory ShowtimeSlot.fromJson(Map<String, dynamic> json) => ShowtimeSlot(
        id: json['id'],
        movieId: json['movieId'],
        cinemaId: json['cinemaId'],
        hallId: json['hallId'],
        date: json['date'],
        startTime: json['startTime'],
        price: (json['price'] as num).toDouble(),
      );
}
