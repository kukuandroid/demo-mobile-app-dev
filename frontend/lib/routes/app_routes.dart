import 'package:get/get.dart';
import '../screens/home/home_screen.dart';
import '../screens/movie_detail/movie_detail_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String movieDetail = '/movie-detail';

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: movieDetail,
      page: () => MovieDetailScreen(
        movie: Get.arguments as Map<String, dynamic>,
      ),
    ),
  ];
}
