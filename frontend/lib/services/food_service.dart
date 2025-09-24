import '../models/food_item.dart';

class FoodService {
  static Future<List<FoodItem>> getFoodItems() async {
    try {
      // TODO: Replace with actual API call when backend is ready
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      return _getMockFoodItems();
    } catch (e) {
      throw Exception('Failed to load food items: $e');
    }
  }

  static List<FoodItem> _getMockFoodItems() {
    return [
      // Combos
      FoodItem(
        id: 'combo_1',
        name: 'Combo 1',
        description: 'Popcorn + Drink',
        price: 10.0,
        imageUrl:
            'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
        category: FoodCategory.combo,
        quantity: 0,
      ),
      FoodItem(
        id: 'combo_2',
        name: 'Combo 2',
        description: 'Nachos + Drink',
        price: 12.0,
        imageUrl:
            'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
        category: FoodCategory.combo,
        quantity: 0,
      ),

      // Snacks
      FoodItem(
        id: 'popcorn',
        name: 'Popcorn',
        description: 'Salted Popcorn',
        price: 6.0,
        imageUrl:
            'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
        category: FoodCategory.snack,
        quantity: 0,
      ),
      FoodItem(
        id: 'nachos',
        name: 'Nachos',
        description: 'Cheesy Nachos',
        price: 8.0,
        imageUrl:
            'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
        category: FoodCategory.snack,
        quantity: 0,
      ),
      FoodItem(
        id: 'fries',
        name: 'Fries',
        description: 'French Fries',
        price: 5.0,
        imageUrl:
            'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
        category: FoodCategory.snack,
        quantity: 0,
      ),

      // Beverages
      FoodItem(
        id: 'coke',
        name: 'Coke',
        description: 'Coca-cola',
        price: 3.0,
        imageUrl:
            'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
        category: FoodCategory.beverage,
        quantity: 0,
      ),
      FoodItem(
        id: 'pepsi',
        name: 'Pepsi',
        description: 'Pepsi',
        price: 3.0,
        imageUrl:
            'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
        category: FoodCategory.beverage,
        quantity: 0,
      ),
      FoodItem(
        id: 'water',
        name: 'Water',
        description: 'Mineral Water',
        price: 2.0,
        imageUrl:
            'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
        category: FoodCategory.beverage,
        quantity: 0,
      ),
    ];
  }
}
