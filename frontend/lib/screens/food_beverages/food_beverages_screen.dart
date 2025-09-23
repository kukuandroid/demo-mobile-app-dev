import 'package:flutter/material.dart';
import 'package:frontend/config/strings.dart';
import 'package:get/get.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import '../../models/food_item.dart';
import '../../models/movie.dart';
import '../../widgets/gradient_button.dart';
import '../booking_summary/booking_summary_screen.dart';

class FoodBeveragesScreen extends StatefulWidget {
  final Movie? movie;
  final String? cinema;
  final DateTime? date;
  final String? time;
  final List<String>? selectedSeats;
  final double? ticketPrice;

  const FoodBeveragesScreen({
    super.key,
    this.movie,
    this.cinema,
    this.date,
    this.time,
    this.selectedSeats,
    this.ticketPrice,
  });

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

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown Date';
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.foodBeveragesTitle,
          actions: [
            TextButton(
              onPressed: () {
                // Handle skip action
                List<FoodItem> selectedItems = [];
                selectedItems.addAll(combos.where((item) => item.quantity > 0));
                selectedItems.addAll(snacks.where((item) => item.quantity > 0));
                selectedItems.addAll(beverages.where((item) => item.quantity > 0));

                Get.to(
                  () => BookingSummaryScreen(
                    movieTitle: widget.movie?.title ?? 'Unknown Movie',
                    imageUrl: widget.movie?.imageUrl ?? '',
                    cinema: widget.cinema ?? 'Unknown Cinema',
                    date: _formatDate(widget.date),
                    time: widget.time ?? 'Unknown Time',
                    selectedSeats: widget.selectedSeats ?? [],
                    ticketPrice: widget.ticketPrice ?? 0.0,
                    selectedFoodItems: selectedItems,
                    foodTotal: getTotalPrice(),
                  ),
                );
              },
              child: const Text(
                AppStrings.skipButton,
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
                    Text(
                      AppStrings.totalPriceLabel,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'RM ${getTotalPrice()}',
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
                    text: AppStrings.confirmButton,
                    onPressed: () {
                      List<FoodItem> selectedItems = [];
                      selectedItems.addAll(combos.where((item) => item.quantity > 0));
                      selectedItems.addAll(snacks.where((item) => item.quantity > 0));
                      selectedItems.addAll(beverages.where((item) => item.quantity > 0));

                      Get.to(
                        () => BookingSummaryScreen(
                          movieTitle: widget.movie?.title ?? 'Unknown Movie',
                          imageUrl: widget.movie?.imageUrl ?? '',
                          cinema: widget.cinema ?? 'Unknown Cinema',
                          date: _formatDate(widget.date),
                          time: widget.time ?? 'Unknown Time',
                          selectedSeats: widget.selectedSeats ?? [],
                          ticketPrice: widget.ticketPrice ?? 0.0,
                          selectedFoodItems: selectedItems,
                          foodTotal: getTotalPrice(),
                        ),
                      );
                    },

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
