import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/cinema_service.dart';
import '../models/movie.dart';

class TicketBookingController extends GetxController {
  // Reactive state variables
  final RxList<String> selectedSeats = <String>[].obs;
  final RxMap<String, bool> unavailableSeats = <String, bool>{}.obs;
  final RxDouble totalPrice = 0.0.obs;
  final RxString selectedLocation = ''.obs;
  final RxString selectedCinema = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString selectedTime = ''.obs;

  final RxList<Map<String, dynamic>> cinemaLocations =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> cinemaHalls = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingCinemas = true.obs;
  final RxString errorMessage = ''.obs;

  // Constants
  static const List<int> vipRows = [0, 1];
  static const double regularSeatPrice = 15.00;
  static const double vipSeatPrice = 25.00;

  // Getters
  bool get hasSelectedSeats => selectedSeats.isNotEmpty;
  bool get hasSelectedLocation => selectedLocation.value.isNotEmpty;
  bool get hasSelectedCinema => selectedCinema.value.isNotEmpty;
  bool get hasSelectedDate => selectedDate.value != null;
  bool get hasSelectedTime => selectedTime.value.isNotEmpty;

  bool get canProceed =>
      hasSelectedSeats &&
      hasSelectedLocation &&
      hasSelectedCinema &&
      hasSelectedDate &&
      hasSelectedTime;

  @override
  void onInit() {
    super.onInit();
    _initializeUnavailableSeats();
    loadCinemaLocations();
  }

  void _initializeUnavailableSeats() {
    unavailableSeats.value = {
      'A1': true,
      'A2': true,
      'B5': true,
      'C3': true,
      'D7': true,
      'E4': true,
      'F9': true,
      'G2': true,
      'H6': true,
      'J8': true,
    };
  }

  Future<void> loadCinemaLocations() async {
    try {
      print('Setting isLoadingCinemas to true');
      isLoadingCinemas.value = true;
      errorMessage.value = '';

      final cinemas = await CinemaService.getAllCinemas();
      print('Cinemas loaded: ${cinemas.length}');
      cinemaLocations.value = List<Map<String, dynamic>>.from(cinemas);
      print('Cinema locations updated: ${cinemaLocations.length}');
    } catch (e) {
      print('Error loading cinemas: $e');
      errorMessage.value = 'Failed to load cinema locations: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      print('Setting isLoadingCinemas to false');
      isLoadingCinemas.value = false;
    }
  }

  void onLocationSelected(String? location) {
    selectedLocation.value = location ?? '';
    selectedCinema.value = '';

    if (location != null && location.isNotEmpty) {
      cinemaHalls.value = cinemaLocations
          .where((cinema) => cinema['city'] == location)
          .map(
            (cinema) => {
              'name': cinema['name'],
              'mall': cinema['mall_or_area'],
            },
          )
          .toList();
    } else {
      cinemaHalls.value = [];
    }
  }

  void onCinemaSelected(String? cinema) {
    selectedCinema.value = cinema ?? '';
  }

  void onDateSelected(DateTime? date) {
    selectedDate.value = date;
  }

  void onTimeSelected(String? time) {
    selectedTime.value = time ?? '';
  }

  void onSeatsSelected(List<String> seats) {
    selectedSeats.clear();
    selectedSeats.addAll(seats);
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    double total = 0;
    for (var seatId in selectedSeats) {
      int row = seatId.codeUnitAt(0) - 65;
      if (vipRows.contains(row)) {
        total += vipSeatPrice;
      } else {
        total += regularSeatPrice;
      }
    }
    totalPrice.value = total;
  }

  int getMonthFromDateString(String dayName) {
    const dayToMonth = {
      'Wed': 8, // August
      'Thur': 8,
      'Fri': 8,
      'Sat': 8,
      'Sun': 8,
      'Mon': 8,
      'Tue': 8,
    };
    return dayToMonth[dayName] ?? 8;
  }

  void clearSelections() {
    selectedSeats.clear();
    selectedLocation.value = '';
    selectedCinema.value = '';
    selectedDate.value = null;
    selectedTime.value = '';
    totalPrice.value = 0.0;
  }

  List<String> get availableLocations {
    return cinemaLocations
        .map<String>((location) => location['city'] as String)
        .toSet()
        .toList();
  }

  List<String> get availableCinemas {
    return cinemaHalls.map<String>((hall) => hall['name'] as String).toList();
  }

  String get selectedCinemaDisplayName {
    if (selectedCinema.value.isEmpty || selectedLocation.value.isEmpty) {
      return '';
    }
    return '${selectedCinema.value}, ${selectedLocation.value}';
  }

  void validateAndProceed(Movie? movie, VoidCallback onSuccess) {
    if (!hasSelectedSeats) {
      Get.snackbar(
        'Validation Error',
        'Please select at least one seat',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!hasSelectedLocation || !hasSelectedCinema) {
      Get.snackbar(
        'Validation Error',
        'Please select cinema location and hall',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!hasSelectedDate || !hasSelectedTime) {
      Get.snackbar(
        'Validation Error',
        'Please select date and time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    onSuccess();
  }

  Future<void> refresh() async {
    await loadCinemaLocations();
  }
}
