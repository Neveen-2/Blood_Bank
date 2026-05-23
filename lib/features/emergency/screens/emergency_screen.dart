import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';

class EmergencyScreen extends StatefulWidget {
  final VoidCallback onBackToHome;

  const EmergencyScreen({super.key, required this.onBackToHome});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _isSending = false;

  Future<void> _sendEmergencyAlert() async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency alert sent successfully!'),
        backgroundColor: AppColors.primary,
      ),
    );
    widget.onBackToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBackToHome,
        ),
        title: const Text('Emergency', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emergency Alert', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            Text(
              'In case of urgent blood needs, send an emergency alert to nearby donors.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightPink,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Urgent request', style: AppTextStyles.heading3),
                    SizedBox(height: 14),
                    Text(
                      'Send a broadcast alert to donors in your area and help save lives faster.',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Send Alert',
              isLoading: _isSending,
              onPressed: _sendEmergencyAlert,
            ),
          ],
        ),
      ),
    );
  }
}
