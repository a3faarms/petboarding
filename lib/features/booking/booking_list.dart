import 'package:flutter/material.dart';
import 'package:pet_boarding_manager/data/booking_model.dart';
import 'package:pet_boarding_manager/data/hive_service.dart';


class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    print("Inside initState");
    _loadBookings();
  }

  void _loadBookings() async {
    print("Inside _loadBookings");
    final results = await HiveService().getBookings();
    print('Loaded ${results.length} bookings from Hive');
    setState(() {
      bookings = results;
    });
  }

  void _removeBooking(int index) async {
    await HiveService().deleteBooking(index);
    _loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📋 Current Bookings')),
      body: bookings.isEmpty
          ? const Center(
              child: Text('No bookings yet. Add your first booking!'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF667EEA), width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              booking.petName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF667EEA),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF667EEA),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                booking.petType.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Owner: ${booking.ownerName} (${booking.ownerPhone})',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Stay: ${_formatDate(booking.checkIn)} → ${_formatDate(booking.checkOut)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (booking.notes != null) ...[
                          const SizedBox(height: 4),
                          Text('Notes: ${booking.notes!}',
                              style: const TextStyle(fontSize: 14)),
                        ],
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _removeBooking(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            child: const Text('Remove'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
