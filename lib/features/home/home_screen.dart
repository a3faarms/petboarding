import 'package:flutter/material.dart';
import 'package:pet_boarding_manager/widgets/header.dart';
import 'package:pet_boarding_manager/widgets/capacity_overview.dart';
import 'package:pet_boarding_manager/features/booking/booking_form.dart';
import 'package:pet_boarding_manager/features/booking/booking_list.dart';
import 'package:pet_boarding_manager/data/booking_model.dart';
import 'package:pet_boarding_manager/data/hive_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pet_boarding_manager/features/calendar/calendar_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String catCapacity = '.';
  String dogCapacity = '.';

  List<Booking> _selectedBookings = [];
  Map<DateTime, List<Booking>> _bookingsByDate = {};

  @override
  void initState() {
    super.initState();
    _loadCapacity();
    _loadAllBookings();
  }

  void _loadCapacity() async {
    final counts = await HiveService().getRoomOccupancyCount(DateTime.now());
    setState(() {
      catCapacity = '${counts['cat']} / 4';
      dogCapacity = '${counts['dog']} / 2';
    });
  }

  void _loadAllBookings() async {
    final bookings = await HiveService().getAllBookings();
    final Map<DateTime, List<Booking>> dateMap = {};

    for (var booking in bookings) {
      DateTime date = DateTime(
          booking.checkIn.year, booking.checkIn.month, booking.checkIn.day);
      while (!date.isAfter(booking.checkOut)) {
        final normalized = DateTime(date.year, date.month, date.day);
        dateMap.putIfAbsent(normalized, () => []).add(booking);
        date = date.add(const Duration(days: 1));
      }
    }

    setState(() {
      _bookingsByDate = dateMap;
      _selectedBookings = _getBookingsForDay(DateTime.now());
    });
  }

  List<Booking> _getBookingsForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return _bookingsByDate[normalized] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          const Header(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CapacityOverview(
              catCapacity: catCapacity,
              dogCapacity: dogCapacity,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Add New Booking',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height:
                                    400, // 🔧 Limit the height so ListView can layout it properly
                                child: BookingFormPage(),
                              ),
                            ],
                          ),
                        ),
                        if (isWide)
                          const SizedBox(width: 20)
                        else
                          const SizedBox(height: 20),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Today\'s Bookings',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              _selectedBookings.isEmpty
                                  ? const Text('No bookings for today.')
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _selectedBookings.length,
                                      itemBuilder: (context, index) {
                                        final booking =
                                            _selectedBookings[index];
                                        return Card(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          child: ListTile(
                                            title: Text(
                                                '${booking.petName} (${booking.petType})'),
                                            subtitle: Text(
                                                'Owner: ${booking.ownerName} • ${booking.ownerPhone}'),
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📅 Booking Calendar',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 400, // 🔧 Limit the height of calendar view
                          child: CalendarPage(
                            bookingsByDate: _bookingsByDate,
                            onDateSelected: (selectedDate) {
                              setState(() {
                                _selectedBookings = _getBookingsForDay(
                                    selectedDate as DateTime);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
