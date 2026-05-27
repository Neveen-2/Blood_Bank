import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';
import 'package:blood_bank/core/widgets/blood_type_card.dart';
import 'package:blood_bank/core/widgets/custom_option_selector.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import 'package:blood_bank/features/auth/services/auth_service.dart';
import 'package:geolocator/geolocator.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({super.key});

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  String selectedBloodType = 'A-';
  String selectedGender = 'Female';
  String selectedRelation = 'Friend';

  bool _loading = false;

  final List<Map<String, String>> bloodGroups = const [
    {'type': 'A+', 'label': 'A Positive', 'sub': '(A+)'},
    {'type': 'B+', 'label': 'B Positive', 'sub': '(B+)'},
    {'type': 'A-', 'label': 'A Negative', 'sub': '(A-)'},
    {'type': 'O-', 'label': 'O Negative', 'sub': '(O-)'},
    {'type': 'O+', 'label': 'O Positive', 'sub': '(O+)'},
    {'type': 'B-', 'label': 'B Negative', 'sub': '(B-)'},
    {'type': 'AB+', 'label': 'AB Positive', 'sub': '(AB+)'},
    {'type': 'AB-', 'label': 'AB Negative', 'sub': '(AB-)'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Become a Donor',
          style: TextStyle(
            color: AppColors.grayNew,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('Select Blood Type', style: AppTextStyles.sectionTitleStyle),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemCount: bloodGroups.length,
              itemBuilder: (context, index) {
                final group = bloodGroups[index];

                return BloodTypeCard(
                  type: group['type']!,
                  label: group['sub']!,
                  isSelected:
                      selectedBloodType ==
                      group['sub']!.replaceAll('(', '').replaceAll(')', ''),
                  onTap: () {
                    setState(() {
                      selectedBloodType = group['sub']!
                          .replaceAll('(', '')
                          .replaceAll(')', '');
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 25),

            Text('Gender', style: AppTextStyles.sectionTitleStyle),
            const SizedBox(height: 10),

            CustomOptionSelector(
              options: const ['Male', 'Female'],
              selectedOption: selectedGender,
              onSelect: (value) => setState(() => selectedGender = value),
            ),

            const SizedBox(height: 25),

            Text('Relation (optional)', style: AppTextStyles.sectionTitleStyle),
            const SizedBox(height: 10),

            CustomOptionSelector(
              options: const ['Family', 'Friend', 'Other'],
              selectedOption: selectedRelation,
              onSelect: (value) => setState(() => selectedRelation = value),
            ),

            const SizedBox(height: 40),

            PrimaryButton(
              text: _loading ? 'Saving...' : 'Become Donor',
              isLoading: _loading,
              onPressed: _registerDonor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerDonor() async {
    try {
      setState(() => _loading = true);

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await AuthService().saveDonorProfile(
        bloodType: selectedBloodType,
        gender: selectedGender,
        relation: selectedRelation,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are now registered as a donor ❤️'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}