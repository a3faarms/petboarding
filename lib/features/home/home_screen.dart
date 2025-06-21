import 'package:flutter/material.dart';
import 'package:pet_boarding_manager/features/booking/booking_form.dart';
import 'package:pet_boarding_manager/features/booking/booking_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  final catCapacity = '0 / 4';
  final dogCapacity = '0 / 2';

  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          _Header(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _CapacityOverview(
              catCapacity: catCapacity,
              dogCapacity: dogCapacity,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BookingFormPage()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Booking'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BookingListPage()),
                      );
                    },
                    icon: const Icon(Icons.list_alt),
                    label: const Text('View Bookings'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 32),
          const SizedBox(height: 32),
        ],
      ),
    ),
  );
}
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: const [
          Text(
            '🐾 Pet Boarding Management',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black26,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Manage your cat and dog boarding schedule with ease',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CapacityOverview extends StatelessWidget {
  final String catCapacity;
  final String dogCapacity;

  const _CapacityOverview({
    required this.catCapacity,
    required this.dogCapacity,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 600;
      return Flex(
        direction: isWide ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CapacityCard(
            title: 'Cat Rooms',
            capacityText: catCapacity,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFEC657)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          const SizedBox(width: 20, height: 20),
          _CapacityCard(
            title: 'Dog Spaces',
            capacityText: dogCapacity,
            gradient: const LinearGradient(
              colors: [Color(0xFF48CAE4), Color(0xFF0077B6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ],
      );
    });
  }
}

class _CapacityCard extends StatelessWidget {
  final String title;
  final String capacityText;
  final Gradient gradient;

  const _CapacityCard({
    required this.title,
    required this.capacityText,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              capacityText,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Available Rooms',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}