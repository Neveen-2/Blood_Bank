import 'package:flutter/material.dart';
import 'package:graduation_project/core/constants/app_colors.dart';

import 'package:graduation_project/view/emergency/emergency_body.dart';
import 'package:graduation_project/view/emergency/app_bar.dart';
import 'package:graduation_project/core/constants/app_enums.dart';
import 'package:graduation_project/view_model/emergency/emergency_view_model.dart';

class EmergencyScreen extends StatefulWidget {
  final VoidCallback onBackToHome;

  const EmergencyScreen({super.key, required this.onBackToHome});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final EmergencyViewModel _viewModel = EmergencyViewModel();

  @override
  void initState() {
    super.initState();

    _viewModel.addListener(() {
      if (!mounted) return;

      setState(() {});

      if (_viewModel.status == EmergencyStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Emergency alert sent successfully!'),
            backgroundColor: AppColors.primary,
          ),
        );

       
        widget.onBackToHome();
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: EmergencyAppBar(onBack: widget.onBackToHome),

      body: EmergencyBody(viewModel: _viewModel),
    );
  }
}
