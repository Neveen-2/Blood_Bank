import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> signup({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    required String bloodType,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Unable to create user');
    }

    double? latitude;
    double? longitude;

    try {
      final locations = await locationFromAddress(address.trim());
      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
      }
    } catch (_) {
      latitude = null;
      longitude = null;
    }

    if (latitude == null || longitude == null) {
      throw Exception('Invalid address');
    }

    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': fullName.trim(),
      'phone': phone.trim(),
      'email': email.trim(),
      'address': address.trim(),
      'bloodType': bloodType.trim(),
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
