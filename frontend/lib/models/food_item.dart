enum FoodCategory { combo, snack, beverage }

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final FoodCategory category;
  int quantity;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.quantity = 0,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    FoodCategory? category,
    int? quantity,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => price * quantity;

  bool get isSelected => quantity > 0;
}
