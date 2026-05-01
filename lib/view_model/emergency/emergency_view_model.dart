import 'package:flutter/material.dart';
import 'package:graduation_project/core/constants/app_enums.dart';

class EmergencyViewModel extends ChangeNotifier {
 
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
    await Future.delayed(const Duration(seconds: 2));
    status = EmergencyStatus.success;
    notifyListeners();
  }

  @override
  void dispose() {
    locationController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
