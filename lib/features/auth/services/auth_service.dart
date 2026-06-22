import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math' show cos, sqrt, asin;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  Future<void> signup({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    required String bloodType,
    required String password,
    required String role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user == null) throw Exception('User creation failed');

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

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'fullName': fullName.trim(),
        'phone': phone.trim(),
        'email': email.trim(),
        'address': address.trim(),
        'bloodType': bloodType.trim(),
        'latitude': latitude,
        'longitude': longitude,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Signup failed');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    try {
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        ),
      );

      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Current password is incorrect');
      }
      throw Exception(e.message ?? 'Password change failed');
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Reset email failed');
    }
  }

  Future<Map<String, dynamic>?> getUserData({required String uid}) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveEmergencyAlert({
    required String userId,
    required String bloodType,
    required String location,
    required String patientGender,
    required String patientRelation,
    String? notes,
  }) async {
    final activityRef = _database.ref("dashboard/activity/emergency").push();

    await activityRef.set({
      'userId': userId,
      'bloodType': bloodType,
      'location': location,
      'gender': patientGender,
      'relation': patientRelation,
      'notes': notes ?? '',
      'status': 'pending',
      'time': DateTime.now().toString(),
    });
  }

  Future<List<Map<String, dynamic>>> searchDonors({
    required String bloodType,
    required double latitude,
    required double longitude,
    double radiusKm = 50,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('bloodType', isEqualTo: bloodType)
          .get();

      final List<Map<String, dynamic>> donors = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        if (data['latitude'] == null || data['longitude'] == null) {
          continue;
        }

        final double donorLat = data['latitude'];
        final double donorLon = data['longitude'];

        final distance = _haversineDistance(
          latitude,
          longitude,
          donorLat,
          donorLon,
        );

        if (distance <= radiusKm) {
          donors.add({...data, 'distance': distance});
        }
      }

      donors.sort((a, b) => a['distance'].compareTo(b['distance']));
      return donors;
    } catch (_) {
      return [];
    }
  }

  double _haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295;
    final a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a));
  }

  User? get currentUser => _auth.currentUser;

  Future<void> saveDonorProfile({
    required String bloodType,
    required String gender,
    required String relation,
    required double latitude,
    required double longitude,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }
    final donationRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('donations')
        .doc();
    await donationRef.set({
      'bloodType': bloodType,
      'gender': gender,
      'relation': relation,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': FieldValue.serverTimestamp(),
    });
    final rtdb = FirebaseDatabase.instance.ref("dashboard");
    final statsSnapshot = await rtdb.child("stats").get();

    final stats = statsSnapshot.value as Map? ?? {};

    final donors = (stats['donors'] ?? 0) + 1;
    final units = (stats['units'] ?? 0) + 1;
    // final month = (stats['month'] ?? 0) + 1;

    await rtdb.update({
      "stats/donors": donors,
      "stats/units": units,
      // "stats/month": month,
    });
    final inventoryRef = FirebaseDatabase.instance.ref("dashboard/inventory");

    final inventorySnapshot = await inventoryRef.get();

    List inventory = [];

    if (inventorySnapshot.value is List) {
      inventory = List.from(inventorySnapshot.value as List);
    } else {
      inventory = [0, 0, 0, 0, 0, 0, 0, 0];
    }
    const bloodMap = {
      "A+": 0,
      "A-": 1,
      "B+": 2,
      "B-": 3,
      "O+": 4,
      "O-": 5,
      "AB+": 6,
      "AB-": 7,
    };

    int index = bloodMap[bloodType] ?? 0;

    inventory[index] = (inventory[index] ?? 0) + 1;

    await inventoryRef.set(inventory);
    final activityRef = FirebaseDatabase.instance.ref(
      "dashboard/activity/donation",
    );

    await activityRef.push().set({
      "bloodType": bloodType,
      "text": "New donation $bloodType added",
      "time": DateTime.now().toString(),
    });
  }
}
