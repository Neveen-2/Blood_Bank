import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_enums.dart';
import 'package:blood_bank/core/widgets/app_dropdown.dart';
import 'package:blood_bank/core/widgets/app_error_box.dart';
import 'package:blood_bank/core/widgets/app_label.dart';
import 'package:blood_bank/core/widgets/app_section_title.dart';
import 'package:blood_bank/core/widgets/app_toggle_button.dart';
import 'package:blood_bank/core/widgets/notes_field.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import 'package:blood_bank/features/auth/services/auth_service.dart';
import 'location_picker_screen.dart' hide Pointer;

class EmergencyScreen extends StatefulWidget {
  final VoidCallback onBackToHome;
  final void Function(String bloodType, String location)? onAlertSent;

  const EmergencyScreen({
    super.key,
    required this.onBackToHome,
    this.onAlertSent,
  });

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _locationController =
      TextEditingController();
  final TextEditingController _notesController =
      TextEditingController();

  String? _selectedBloodType;
  PatientGender _selectedGender = PatientGender.male;
  PatientRelation _selectedRelation = PatientRelation.family;
  EmergencyStatus _status = EmergencyStatus.idle;

  bool _isPickingLocation = false;

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    if (_isPickingLocation) return;

    _isPickingLocation = true;

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationPickerScreen(),
      ),
    );

    _isPickingLocation = false;

    if (result != null) {
      setState(() {
        _locationController.text =
            result['location'] ?? '';
      });
    }
  }

  Future<void> _sendEmergencyAlert() async {
    // Validate Notes field
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate blood type and location
    if (_selectedBloodType == null ||
        _locationController.text.isEmpty) {
      setState(() => _status = EmergencyStatus.error);
      return;
    }

    setState(() => _status = EmergencyStatus.loading);

    try {
      final auth = AuthService();

      print("USER ID: ${auth.currentUser?.uid}");

      final user = auth.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      await auth.saveEmergencyAlert(
        userId: user.uid,
        bloodType: _selectedBloodType!,
        location: _locationController.text,
        patientGender: _selectedGender.name,
        patientRelation: _selectedRelation.name,
        notes: _notesController.text,
      );

      if (!mounted) return;

      setState(() => _status = EmergencyStatus.success);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Emergency alert sent successfully!',
          ),
          backgroundColor: AppColors.primary,
        ),
      );

      widget.onAlertSent?.call(
        _selectedBloodType!,
        _locationController.text,
      );

      Future.delayed(
        const Duration(seconds: 1),
        () {
          if (mounted) {
            widget.onBackToHome();
          }
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _status = EmergencyStatus.error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
          ),
          onPressed: widget.onBackToHome,
        ),
        title: const Text(
          'Emergency Request',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const AppSectionTitle(
                'Blood Request Details',
              ),

              const SizedBox(height: 16),

              AppDropdown<String>(
                selectedValue:
                    _selectedBloodType,
                items: const [
                  'A+',
                  'A-',
                  'B+',
                  'B-',
                  'O+',
                  'O-',
                  'AB+',
                  'AB-',
                ],
                onChanged: (value) =>
                    setState(
                  () => _selectedBloodType =
                      value,
                ),
                hint: 'Select blood type',
                itemLabel: (item) => item,
              ),

              const SizedBox(height: 16),

              const AppLabel('Location'),

              const SizedBox(height: 8),

              GestureDetector(
                onTap: _pickLocation,
                child: Container(
                  padding:
                      const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          Colors.grey.shade300,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                    color:
                        Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .location_on_outlined,
                      ),
                      const SizedBox(
                          width: 10),
                      Expanded(
                        child: Text(
                          _locationController
                                  .text
                                  .isEmpty
                              ? 'Select your location'
                              : _locationController
                                  .text,
                          style: TextStyle(
                            color:
                                _locationController
                                        .text
                                        .isEmpty
                                    ? Colors.grey
                                    : AppColors
                                        .primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const AppLabel('Notes'),

              const SizedBox(height: 8),

              NotesField(
                controller:
                    _notesController,
              ),

              const SizedBox(height: 20),

              const AppLabel('Gender'),

              Row(
                children: [
                  AppToggleButton(
                    label: 'Male',
                    isSelected:
                        _selectedGender ==
                            PatientGender
                                .male,
                    onTap: () =>
                        setState(
                      () =>
                          _selectedGender =
                              PatientGender
                                  .male,
                    ),
                  ),

                  const SizedBox(
                      width: 12),

                  AppToggleButton(
                    label: 'Female',
                    isSelected:
                        _selectedGender ==
                            PatientGender
                                .female,
                    onTap: () =>
                        setState(
                      () =>
                          _selectedGender =
                              PatientGender
                                  .female,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (_status ==
                  EmergencyStatus.error)
                const AppErrorBox(
                  message:
                      'Please fill blood type and location',
                ),

              PrimaryButton(
                text:
                    'Send Emergency Alert',
                isLoading:
                    _status ==
                        EmergencyStatus
                            .loading,
                onPressed:
                    _sendEmergencyAlert,
              ),
            ],
          ),
        ),
      ),
    );
  }
}