import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/strings.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/food_item_card.dart';
import '../../widgets/food_category_tabs.dart';
import '../../widgets/food_bottom_sheet.dart';
import '../../controllers/food_beverages_controller.dart';
import '../../models/food_item.dart';
import '../../models/movie.dart';
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

class _FoodBeveragesScreenState extends State<FoodBeveragesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late FoodBeveragesController _controller;

  final List<String> _categories = ['Combos', 'Snacks', 'Beverages'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _controller = Get.put(FoodBeveragesController());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown Date';
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _navigateToBookingSummary() {
    Get.to(
      () => BookingSummaryScreen(
        movieTitle: widget.movie?.title ?? 'Unknown Movie',
        imageUrl: widget.movie?.imageUrl ?? '',
        cinema: widget.cinema ?? 'Unknown Cinema',
        date: _formatDate(widget.date),
        time: widget.time ?? 'Unknown Time',
        selectedSeats: widget.selectedSeats ?? [],
        ticketPrice: widget.ticketPrice ?? 0.0,
        selectedFoodItems: _controller.selectedItems,
        foodTotal: _controller.totalPrice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.foodBeveragesTitle,
        actions: [
          TextButton(
            onPressed: _navigateToBookingSummary,
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
      body: GetBuilder<FoodBeveragesController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Category tabs
              FoodCategoryTabs(
                tabController: _tabController,
                categories: _categories,
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFoodList(controller.combos),
                    _buildFoodList(controller.snacks),
                    _buildFoodList(controller.beverages),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: FoodBottomSheet(
        onConfirm: _navigateToBookingSummary,
        onSkip: _navigateToBookingSummary,
      ),
    );
  }

  Widget _buildFoodList(List<FoodItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No items available',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _controller.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return FoodItemCard(
            item: item,
            onIncrement: () => _controller.incrementQuantity(item.id),
            onDecrement: () => _controller.decrementQuantity(item.id),
          );
        },
      ),
    );
  }
}
