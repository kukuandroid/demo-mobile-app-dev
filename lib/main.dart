import 'package:cinemabooking/config/theme.dart';
import 'package:cinemabooking/features/booking/providers/booking_provider.dart';
import 'package:cinemabooking/features/booking/views/booking_history_view.dart';
import 'package:cinemabooking/features/cinema/providers/cinema_provider.dart';
import 'package:cinemabooking/features/cinema/views/cinema_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/views/splash_screen.dart';
import 'features/auth/views/login_screen.dart';
import 'features/auth/views/register_screen.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/profile/views/profile_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CinemaProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Cinema Booking',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: AppTheme.primary,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const AuthGate(child: CinemaListView()),
          '/history': (context) => const AuthGate(child: BookingHistoryView()),
          '/profile': (context) => const AuthGate(child: ProfileView()),
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  final Widget child;
  const AuthGate({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (!authProvider.isLoggedIn) {
      // Redirect to login if not logged in
      // Use Future.microtask to avoid build context issues
      Future.microtask(() {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const SizedBox.shrink();
    }
    return child;
  }
}
