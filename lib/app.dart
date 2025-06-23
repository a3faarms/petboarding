import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'features/booking/booking_form.dart';
import 'features/booking/booking_list.dart';


class PetBoardingApp extends StatelessWidget {
  const PetBoardingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Boarding Manager',
      debugShowCheckedModeBanner: false,
      theme: _appTheme,
      home: const HomeScreen(),
      routes: {
        '/booking': (context) => const BookingFormPage(),
        '/bookings': (context) => const BookingListPage(),
      },
    );
  }
}

/// Custom ThemeData based on your HTML design
final ThemeData _appTheme = ThemeData(
  fontFamily: 'Segoe UI',
  scaffoldBackgroundColor: const Color(0xFFF8F9FA),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.indigo,
  ).copyWith(
    primary: const Color(0xFF667EEA),
    secondary: const Color(0xFF764BA2),
  ),
  appBarTheme: const AppBarTheme(
    elevation: 4,
    backgroundColor: Color(0xFF667EEA),
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    elevation: 4,
    margin: EdgeInsets.all(12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    color: Colors.white,
    shadowColor: Colors.black12,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      backgroundColor: const Color(0xFF667EEA),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      elevation: 3,
    ),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF667EEA),
    ),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
  ),
);

