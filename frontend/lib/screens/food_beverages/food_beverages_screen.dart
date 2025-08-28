import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import '../../models/food_item.dart';
import '../../widgets/gradient_button.dart';

class FoodBeveragesScreen extends StatefulWidget {
  const FoodBeveragesScreen({super.key});

  @override
  State<FoodBeveragesScreen> createState() => _FoodBeveragesScreenState();
}

class _FoodBeveragesScreenState extends State<FoodBeveragesScreen> {
  final List<FoodItem> combos = [
    FoodItem(
      name: 'Combo 1',
      description: 'Popcorn + Drink',
      price: 10.0,
      image:
          'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
    ),
    FoodItem(
      name: 'Combo 2',
      description: 'Nachos + Drink',
      price: 12.0,
      image:
          'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
    ),
  ];

  final List<FoodItem> snacks = [
    FoodItem(
      name: 'Popcorn',
      description: 'Salted Popcorn',
      price: 6.0,
      image:
          'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
    ),
    FoodItem(
      name: 'Nachos',
      description: 'Cheesy Nachos',
      price: 8.0,
      image:
          'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
    ),
    FoodItem(
      name: 'Fries',
      description: 'French Fries',
      price: 5.0,
      image:
          'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
    ),
  ];

  final List<FoodItem> beverages = [
    FoodItem(
      name: 'Coke',
      description: 'Coca-cola',
      price: 3.0,
      image:
          'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
    ),
    FoodItem(
      name: 'Pepsi',
      description: 'Pepsi',
      price: 3.0,
      image:
          'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
    ),
    FoodItem(
      name: 'Water',
      description: 'Mineral Water',
      price: 2.0,
      image:
          'https://wholefully.com/wp-content/uploads/2014/02/movie-theatre-popcorn.jpg',
    ),
  ];

  double getTotalPrice() {
    double totalPrice = 0;
    for (var item in combos) {
      totalPrice += item.price * item.quantity;
    }
    for (var item in snacks) {
      totalPrice += item.price * item.quantity;
    }
    for (var item in beverages) {
      totalPrice += item.price * item.quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Beverages & Food',
          actions: [
            TextButton(
              onPressed: () {
                // Handle skip action
                Get.toNamed(AppRoutes.bookingSummary);
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildFoodList(combos),
            _buildFoodList(snacks),
            _buildFoodList(beverages),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Total price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      '\${getTotalPrice().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: 'Confirm',
                    onPressed: () {
                      Get.toNamed(AppRoutes.bookingSummary);
                    },
                    gradientColors: const [
                      Color(0xFF6C63FF),
                      Color(0xFF9C27B0),
                    ],
                    height: 54,
                    borderRadius: BorderRadius.circular(12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodList(List<FoodItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.network(
                  item.image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(item.description),
                      Text(
                        '${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (item.quantity > 0) {
                            item.quantity--;
                          }
                        });
                      },
                    ),
                    Text(item.quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          item.quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
