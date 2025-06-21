import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'booking_model.dart';

class IsarService {
  static late final Isar isar;

  static Future<void> initialize() async {
    late String dirPath;

    if (kIsWeb) {
      dirPath = 'isar_web'; // 👈 Dummy value, required by Isar for Web
    } else {
      final dir = await getApplicationSupportDirectory();
      dirPath = dir.path;
    }

    isar = await Isar.open(
      [BookingSchema],
      directory: dirPath,
    );
  }

  Future<void> saveBooking(Booking booking) async {
    await isar.writeTxn(() async {
      await isar.bookings.put(booking);
    });
  }

  Future<List<Booking>> getAllBookings() async {
    return await isar.bookings.where().sortByCheckIn().findAll();
  }

  Future<void> deleteBooking(int id) async {
    await isar.writeTxn(() async {
      await isar.bookings.delete(id);
    });
  }
}
