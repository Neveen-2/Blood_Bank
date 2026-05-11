import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/blood_type_card.dart';
import '../../core/widgets/custom_option_selector.dart';

class SelectBloodGroupView extends StatefulWidget {
  const SelectBloodGroupView({super.key});

  @override
  State<SelectBloodGroupView> createState() => _SelectBloodGroupViewState();
}

class _SelectBloodGroupViewState extends State<SelectBloodGroupView> {
  String selectedBloodType = 'A-';
  String selectedGender = 'Female';
  String selectedRelation = 'Friend';

  final List<Map<String, String>> bloodGroups = [
    {'type': 'AB', 'label': 'A Positive', 'sub': '(A+)'},
    {'type': 'B+', 'label': 'B Positive', 'sub': '(B+)'},
    {'type': 'A-', 'label': 'A Negative', 'sub': '(A-)'},
    {'type': 'O-', 'label': 'O Negative', 'sub': '(O-)'},
    {'type': 'O+', 'label': 'O Positive', 'sub': '(O+)'},
    {'type': 'B-', 'label': 'B Negative', 'sub': '(B-)'},
    {'type': 'AB+', 'label': 'AB Positive', 'sub': '(AB+)'},
    {'type': 'AB', 'label': 'A Positive', 'sub': '(A+)'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.grey),
        title: const Text(
          "Select Blood Group",
          style: TextStyle(
            color: AppColors.grayNew,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

                  label: "${group['label']!}\n${group['sub']!}",
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

            const SizedBox(height: 30),

            Text("Patient Gender", style: AppTextStyles.sectionTitleStyle),
            const SizedBox(height: 15),
            CustomOptionSelector(
              options: const ['Male', 'Female'],
              selectedOption: selectedGender,
              onSelect: (value) => setState(() => selectedGender = value),
            ),

            const SizedBox(height: 30),

            Text("Patient Relation", style: AppTextStyles.sectionTitleStyle),
            const SizedBox(height: 15),
            CustomOptionSelector(
              options: const ['Family', 'Friend', 'Other'],
              selectedOption: selectedRelation,
              onSelect: (value) => setState(() => selectedRelation = value),
            ),

            const SizedBox(height: 50),

            PrimaryButton(
              text: "Emergency",
              onPressed: () {
                debugPrint(
                  "Selected: $selectedBloodType, $selectedGender, $selectedRelation",
                );
              },
              isLoading: false,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
