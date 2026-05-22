import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = 'Naveen';
  String urgentBloodType = 'O-';
  String urgentLocation = 'aaa';
  final DatabaseReference _db = FirebaseDatabase.instance.ref("");

  // Nearby donors list
  List<Map<String, dynamic>> nearbyDonors = [];

  // List of recent emergencies
  void listenToEmergencies() {
    _db.child("emergencies").orderByChild("time").limitToLast(1).onValue.listen(
      (event) {
        final data = event.snapshot.value;

        if (data == null) {
          urgentBloodType = '';
          urgentLocation = '';
          notifyListeners();
          return;
        }

        final map = Map<String, dynamic>.from(data as Map);

        final latestKey = map.keys.first;
        final item = Map<String, dynamic>.from(map[latestKey]);

        if (item['status'] == 'pending') {
          urgentBloodType = item['bloodType'] ?? '';
          urgentLocation = item['location'] ?? '';
        } else {
          urgentBloodType = '';
          urgentLocation = '';
        }

        notifyListeners();
      },
    );
  }

  void listenToUserData() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _firestore.collection('users').doc(user.uid).snapshots().listen((doc) {
          if (doc.exists) {
            userName = doc.data()?['fullName'] ?? '';
            notifyListeners();
          }
        });
      }
    });
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied");
    }
  }

  Future<void> loadNearbyDonors() async {
    await requestLocationPermission();

    Position position = await Geolocator.getCurrentPosition();
    final currentUser = FirebaseAuth.instance.currentUser;
    final snapshot = await _firestore.collection('users').get();

    List<Map<String, dynamic>> tempList = [];

    for (var doc in snapshot.docs) {
      if (doc.id == currentUser!.uid) continue;
      final data = doc.data();

      if (data['latitude'] == null || data['longitude'] == null) continue;

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        data['latitude'],
        data['longitude'],
      );

      if (distance <= 200000) {
        tempList.add({
          'name': data['fullName'] ?? '',
          'blood': data['bloodType'] ?? '',
          'distance': '${(distance / 1000).toStringAsFixed(1)} km',
        });
      }
    }

    nearbyDonors = tempList;
    notifyListeners();
  }

  HomeViewModel() {
    listenToEmergencies();
    listenToUserData();
    loadNearbyDonors();
    
  }
}
