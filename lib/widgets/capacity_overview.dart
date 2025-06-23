import 'package:flutter/material.dart';

class CapacityOverview extends StatelessWidget {
  final String catCapacity;
  final String dogCapacity;

  const CapacityOverview({
    super.key,
    required this.catCapacity,
    required this.dogCapacity,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
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
