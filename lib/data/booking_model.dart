import 'package:hive/hive.dart';

part 'booking_model.g.dart';

@HiveType(typeId: 0)
class Booking extends HiveObject {
  @HiveField(0)
  String petName;

  @HiveField(1)
  String petType;

  @HiveField(2)
  String ownerName;

  @HiveField(3)
  String ownerPhone;

  @HiveField(4)
  DateTime checkIn;

  @HiveField(5)
  DateTime checkOut;

  @HiveField(6)
  String? notes;

  Booking({
    required this.petName,
    required this.petType,
    required this.ownerName,
    required this.ownerPhone,
    required this.checkIn,
    required this.checkOut,
    this.notes,
  });
}
