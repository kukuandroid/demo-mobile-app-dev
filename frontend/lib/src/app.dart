import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config.dart';
import 'core/network/api_client.dart';
import 'features/movies/movie_list_viewmodel.dart';
import 'features/movies/movie_list_screen.dart';
import 'features/movies/movie_detail_screen.dart';
import 'features/booking/booking_viewmodel.dart';
import 'features/booking/booking_screen.dart';
import 'features/booking/booking_selection_screen.dart';
import 'features/booking/booking_summary_screen.dart';
import 'features/fnb/fnb_viewmodel.dart';
import 'features/fnb/fnb_screen.dart';
import 'features/payment/payment_viewmodel.dart';
import 'features/payment/payment_screen.dart';
import 'features/payment/payment_method_screen.dart';
import 'features/payment/payment_success_screen.dart';

class CinemaApp extends StatelessWidget {
  const CinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig();
    final apiClient = ApiClient(baseUrl: config.baseUrl);

    return MultiProvider(
      providers: [
        Provider.value(value: config),
        Provider.value(value: apiClient),
        ChangeNotifierProvider(create: (_) => MovieListViewModel(apiClient)),
        ChangeNotifierProvider(create: (_) => BookingViewModel(apiClient)),
        ChangeNotifierProvider(create: (_) => FnbViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel(apiClient)),
      ],
      child: MaterialApp(
        title: 'Cinema Booking',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        initialRoute: MovieListScreen.routeName,
        routes: {
          MovieListScreen.routeName: (_) => const MovieListScreen(),
          MovieDetailScreen.routeName: (_) => const MovieDetailScreen(),
          BookingSelectionScreen.routeName: (_) => const BookingSelectionScreen(),
          BookingScreen.routeName: (_) => const BookingScreen(),
          FnbScreen.routeName: (_) => const FnbScreen(),
          BookingSummaryScreen.routeName: (_) => const BookingSummaryScreen(),
          PaymentScreen.routeName: (_) => const PaymentScreen(),
          PaymentMethodScreen.routeName: (_) => const PaymentMethodScreen(),
          PaymentSuccessScreen.routeName: (_) => const PaymentSuccessScreen(),
        },
      ),
    );
  }
}
