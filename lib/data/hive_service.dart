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
    print('Box now has ${box.length} bookings');
    await box.add(booking);
  }

  Future<List<Booking>> getBookings() async {
    final box = Hive.box<Booking>(_boxName);
    return box.values.toList();
  }

  Future<void> deleteBooking(int index) async {
    final box = Hive.box<Booking>(_boxName);
    await box.deleteAt(index);
  }
}
