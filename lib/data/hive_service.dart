import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'booking_model.dart';

class HiveService {
  static const _boxName = 'bookings';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(BookingAdapter());
    await Hive.openBox<Booking>('bookings');
  }

  Future<void> addBooking(Booking booking) async {
    final box = Hive.box<Booking>(_boxName);
     print('Before add: ${box.length}');
    await box.add(booking);
     print('After add: ${box.length}');
  }

  Future<List<Booking>> getBookings() async {
    final box = Hive.box<Booking>(_boxName);
    return box.values.toList();
  }

  Future<List<Booking>> getAllBookings() async {
    final box = await Hive.openBox<Booking>(_boxName);
    return box.values.toList();
  }

  Future<void> deleteBooking(int index) async {
    final box = Hive.box<Booking>(_boxName);
    await box.deleteAt(index);
  }
    Future<Map<String, int>> getRoomOccupancyCount(DateTime targetDate) async {
    final box = Hive.box<Booking>('bookings');
    final bookings = box.values.toList();

    int catCount = 0;
    int dogCount = 0;

    for (final booking in bookings) {
        final inDate = booking.checkIn;
        final outDate = booking.checkOut;

        if (!inDate.isAfter(targetDate) && outDate.isAfter(targetDate)) {
        if (booking.petType == 'cat') catCount++;
        if (booking.petType == 'dog') dogCount++;
        }
    }

    return {'cat': catCount, 'dog': dogCount};
    }
}
