import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = 'Naveen';
  String urgentBloodType = 'O-';
  String urgentLocation = 'aaa';
  final DatabaseReference _db = FirebaseDatabase.instance.ref("emergencies");

  // Nearby donors list
  final List<Map<String, String>> nearbyDonors = [
    {'name': 'Ahmed Ali', 'blood': 'O-', 'distance': '1.2 km'},
    {'name': 'Sara Mohamed', 'blood': 'A+', 'distance': '2.5 km'},
    {'name': 'Omar Hassan', 'blood': 'B+', 'distance': '3.1 km'},
  ];
  
  // List of recent emergencies
  void listenToEmergencies() {
    _db.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data == null) return;

      final map = Map<String, dynamic>.from(data as Map);

      Map<String, dynamic>? latestEmergency;

      map.forEach((key, value) {
        final item = Map<String, dynamic>.from(value);

        if (item['status'] == 'pending') {
          latestEmergency = item;
        }
      });

      if (latestEmergency != null) {
        urgentBloodType = latestEmergency!['bloodType'] ?? '';
        urgentLocation = latestEmergency!['location'] ?? '';
      }

      notifyListeners();
    });
  }

  void listenToUserData() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _firestore
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((doc) {
          if (doc.exists) {
            userName = doc.data()?['fullName'] ?? '';
            notifyListeners();
          }
        });
      }
    });
  }

  HomeViewModel() {
    listenToEmergencies();
    listenToUserData();
  }
}
