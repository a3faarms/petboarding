import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'features/booking/booking_form.dart';
import 'features/booking/booking_list.dart';
import 'core/theme/app_theme.dart';

class PetBoardingApp extends StatelessWidget {
  const PetBoardingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Boarding Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      routes: {
        '/booking': (context) => const BookingFormPage(),
        '/bookings': (context) => const BookingListPage(),
      },
    );
  }
}