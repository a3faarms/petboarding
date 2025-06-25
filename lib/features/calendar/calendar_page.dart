import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pet_boarding_manager/data/booking_model.dart';

class CalendarPage extends StatefulWidget {
  final Map<DateTime, List<Booking>> bookingsByDate;
  final void Function(List<Booking>) onDateSelected;

  const CalendarPage({
    super.key,
    required this.bookingsByDate,
    required this.onDateSelected,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Booking> _getEventsForDay(DateTime day) {
    return widget.bookingsByDate[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Booking>(
          focusedDay: _focusedDay,
          firstDay: DateTime(2020),
          lastDay: DateTime(2100),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getEventsForDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDateSelected(_getEventsForDay(selectedDay));
          },
          calendarStyle: const CalendarStyle(
            markerDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            todayDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            selectedDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }
}
