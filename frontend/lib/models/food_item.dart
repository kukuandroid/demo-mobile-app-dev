class FoodItem {
  final String name;
  final String description;
  final double price;
  final String image;
  int quantity;

  FoodItem({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.quantity = 0,
  });
}
