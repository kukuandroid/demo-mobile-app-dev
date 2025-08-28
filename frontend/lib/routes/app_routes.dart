import 'package:frontend/screens/booking_summary/booking_summary_screen.dart';
import 'package:frontend/screens/food_beverages/food_beverages_screen.dart';
import 'package:frontend/screens/payment_method/payment_method_screen.dart';
import 'package:frontend/screens/ticket_booking/ticket_booking_screen.dart';
import 'package:get/get.dart';
import '../screens/home/home_screen.dart';
import '../screens/movie_detail/movie_detail_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String movieDetail = '/movie-detail';
  static const String ticketBooking = '/ticket-booking';
  static const String bookingSummary = '/booking-summary';
  static const String foodBeverages = '/food-beverages';
  static const String paymentMethod = '/payment-method';

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(
      name: movieDetail,
      page: () =>
          MovieDetailScreen(movie: Get.arguments as Map<String, dynamic>),
    ),
    GetPage(
      name: AppRoutes.ticketBooking,
      page: () => const TicketBookingScreen(),
    ),
    GetPage(
      name: AppRoutes.bookingSummary,
      page: () => const BookingSummaryScreen(),
    ),
    GetPage(
      name: AppRoutes.foodBeverages,
      page: () => const FoodBeveragesScreen(),
    ),
    GetPage(
      name: AppRoutes.paymentMethod,
      page: () => const PaymentMethodScreen(),
    ),
  ];
}
