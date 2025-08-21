import 'package:cinemabooking/config/theme.dart';
import 'package:cinemabooking/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cinema_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/auth_provider.dart';
import 'views/cinema_list_view.dart';
import 'views/booking_history_view.dart';
import 'views/splash_screen.dart';
import 'views/login_screen.dart';

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
