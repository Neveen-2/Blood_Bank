import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_enums.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyViewModel extends ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  String? selectedBloodType;
  PatientGender selectedGender = PatientGender.male;
  PatientRelation selectedRelation = PatientRelation.friend;
  EmergencyStatus status = EmergencyStatus.idle;

  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool get isLoading => status == EmergencyStatus.loading;

  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  void selectBloodType(String? value) {
    selectedBloodType = value;
    notifyListeners();
  }

  void selectGender(PatientGender gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void selectRelation(PatientRelation relation) {
    selectedRelation = relation;
    notifyListeners();
  }

  Future<void> sendEmergencyAlert() async {
    if (selectedBloodType == null || locationController.text.isEmpty) {
      status = EmergencyStatus.error;
      notifyListeners();
      return;
    }
    status = EmergencyStatus.loading;
    notifyListeners();
    // await Future.delayed(const Duration(seconds: 2));
    // status = EmergencyStatus.success;

    //realtime database
    try {
      final user = FirebaseAuth.instance.currentUser;

      await _db.child("emergencies").push().set({
        "userId": user?.uid,
        "bloodType": selectedBloodType,
        "gender": selectedGender.name,
        "relation": selectedRelation.name,
        "location": locationController.text.trim(),
        "notes": notesController.text.trim(),
        "time": DateTime.now().toString(),
        "status": "pending",
      });

      status = EmergencyStatus.success;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
      status = EmergencyStatus.error;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    locationController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
