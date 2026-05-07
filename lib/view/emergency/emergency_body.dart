import 'package:flutter/material.dart';
import 'package:blood_bank/core/widgets/app_text_field.dart';
import 'package:blood_bank/core/widgets/app_error_box.dart';
import 'package:blood_bank/core/widgets/notes_field.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import 'package:blood_bank/core/widgets/app_section_title.dart';
import 'package:blood_bank/core/widgets/app_label.dart';
import 'package:blood_bank/core/widgets/app_dropdown.dart';
import 'package:blood_bank/core/widgets/app_toggle_button.dart';
import 'package:blood_bank/core/constants/app_enums.dart';
import 'package:blood_bank/view_model/emergency/emergency_view_model.dart';

class EmergencyBody extends StatelessWidget {
  final EmergencyViewModel viewModel;

  const EmergencyBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle('Blood Request Details'),
          const SizedBox(height: 16),

          AppDropdown<String>(
            selectedValue: viewModel.selectedBloodType,
            items: viewModel.bloodTypes,
            onChanged: viewModel.selectBloodType,
            hint: 'Select blood type',
            itemLabel: (item) => item,
          ),

          const SizedBox(height: 16),

          const AppLabel('Location'),
          const SizedBox(height: 8),

          AppTextField(
            hint: 'Enter your location',
            prefixIcon: Icons.location_on_outlined,
            controller: viewModel.locationController,
          ),

          const SizedBox(height: 16),

          const AppLabel('Additional Notes'),
          const SizedBox(height: 8),

          NotesField(controller: viewModel.notesController),

          const SizedBox(height: 20),

          const AppLabel('Patient Gender'),
          const SizedBox(height: 10),

          _GenderToggle(
            selectedGender: viewModel.selectedGender,
            onChanged: viewModel.selectGender,
          ),

          const SizedBox(height: 20),

          const AppLabel('Patient Relation'),
          const SizedBox(height: 10),

          _RelationToggle(
            selectedRelation: viewModel.selectedRelation,
            onChanged: viewModel.selectRelation,
          ),

          const SizedBox(height: 32),

          if (viewModel.status == EmergencyStatus.error)
            const AppErrorBox(message: 'Please fill blood type and location'),

          PrimaryButton(
            text: 'Send Emergency Alert',
            onPressed: viewModel.sendEmergencyAlert,
            isLoading: viewModel.isLoading,
          ),
        ],
      ),
    );
  }
}

//  Private Toggle Widgets 

class _GenderToggle extends StatelessWidget {
  final PatientGender selectedGender;
  final Function(PatientGender) onChanged;

  const _GenderToggle({required this.selectedGender, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppToggleButton(
          label: 'Male',
          isSelected: selectedGender == PatientGender.male,
          onTap: () => onChanged(PatientGender.male),
        ),
        const SizedBox(width: 12),
        AppToggleButton(
          label: 'Female',
          isSelected: selectedGender == PatientGender.female,
          onTap: () => onChanged(PatientGender.female),
        ),
      ],
    );
  }
}

class _RelationToggle extends StatelessWidget {
  final PatientRelation selectedRelation;
  final Function(PatientRelation) onChanged;

  const _RelationToggle({
    required this.selectedRelation,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: PatientRelation.values.map((relation) {
        final isSelected = relation == selectedRelation;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: AppToggleButton(
            label: relation.name,
            isSelected: isSelected,
            onTap: () => onChanged(relation),
          ),
        );
      }).toList(),
    );
  }
}