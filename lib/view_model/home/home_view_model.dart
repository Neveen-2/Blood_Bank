import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  String userName = 'Naveen';
  String urgentBloodType = 'O-';
  String urgentLocation = 'aaa';

  // Nearby donors list 
  final List<Map<String, String>> nearbyDonors = [
    {'name': 'Ahmed Ali', 'blood': 'O-', 'distance': '1.2 km'},
    {'name': 'Sara Mohamed', 'blood': 'A+', 'distance': '2.5 km'},
    {'name': 'Omar Hassan', 'blood': 'B+', 'distance': '3.1 km'},
  ];
}