import 'package:flutter/material.dart';

class PetBoardingApp extends StatelessWidget {
  const PetBoardingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Boarding Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Placeholder(),
    );
  }
}
