import 'package:get/get.dart';
import '../models/food_item.dart';
import '../services/food_service.dart';

class FoodBeveragesController extends GetxController {
  final RxList<FoodItem> _allFoodItems = <FoodItem>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  List<FoodItem> get allFoodItems => _allFoodItems;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  List<FoodItem> get combos => _allFoodItems
      .where((item) => item.category == FoodCategory.combo)
      .toList();
  List<FoodItem> get snacks => _allFoodItems
      .where((item) => item.category == FoodCategory.snack)
      .toList();
  List<FoodItem> get beverages => _allFoodItems
      .where((item) => item.category == FoodCategory.beverage)
      .toList();

  List<FoodItem> get selectedItems =>
      _allFoodItems.where((item) => item.isSelected).toList();

  double get totalPrice {
    return _allFoodItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  void onInit() {
    super.onInit();
    loadFoodItems();
  }

  Future<void> loadFoodItems() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final items = await FoodService.getFoodItems();
      _allFoodItems.value = items;
    } catch (e) {
      _errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load food items: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity < 0) return;

    final index = _allFoodItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _allFoodItems[index] = _allFoodItems[index].copyWith(quantity: quantity);
    }
  }

  void incrementQuantity(String itemId) {
    final index = _allFoodItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final currentQuantity = _allFoodItems[index].quantity;
      updateQuantity(itemId, currentQuantity + 1);
    }
  }

  void decrementQuantity(String itemId) {
    final index = _allFoodItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final currentQuantity = _allFoodItems[index].quantity;
      updateQuantity(
        itemId,
        (currentQuantity - 1).clamp(0, double.infinity).toInt(),
      );
    }
  }

  void clearAllSelections() {
    for (int i = 0; i < _allFoodItems.length; i++) {
      _allFoodItems[i] = _allFoodItems[i].copyWith(quantity: 0);
    }
  }

  bool get hasSelectedItems => selectedItems.isNotEmpty;

  Future<void> refresh() async {
    await loadFoodItems();
  }
}
