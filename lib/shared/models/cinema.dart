class Cinema {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double rating;
  final List<String> amenities;
  final String description;

  Cinema({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.amenities,
    required this.description,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      location: json['location'],
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      amenities: List<String>.from(json['amenities'] ?? []),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'rating': rating,
      'amenities': amenities,
      'description': description,
    };
  }
}
