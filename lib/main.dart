import 'package:flutter/material.dart';
import 'app.dart';
import 'package:pet_boarding_manager/data/hive_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await HiveService.init();
  runApp(const PetBoardingApp());
}
