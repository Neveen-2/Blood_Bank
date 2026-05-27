import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:blood_bank/core/constants/app_assets.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_routes.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';
import 'package:blood_bank/core/widgets/profile_data_field.dart';

import 'package:blood_bank/features/profile/screens/change_password_screen.dart';
import 'package:blood_bank/features/auth/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data();
  }

  Future<List<QueryDocumentSnapshot>> _getDonations() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('donations')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs;
  }

  Widget _card(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final user = FirebaseAuth.instance.currentUser;

          final name = data?['fullName'] ?? 'User';
          final phone = data?['phone'] ?? 'No phone';
          final blood = data?['bloodType'] ?? 'N/A';
          final email = user?.email ?? 'No email';

          final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

          return Column(
            children: [
              Container(
                height: 170,
                width: double.infinity,
                color: AppColors.primary,
                child: SafeArea(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 10,
                        left: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.home,
                              );
                            }
                          },
                        ),
                      ),
                      const Text(
                        'Profile',
                        style: AppTextStyles.font18WhiteBold,
                      ),

                      Positioned(
                        bottom: -45,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _card(ProfileDataField(label: 'Username', hint: name)),
                      _card(ProfileDataField(label: 'Email', hint: email)),
                      _card(
                        ProfileDataField(label: 'Phone Number', hint: phone),
                      ),
                      _card(ProfileDataField(label: 'Blood type', hint: blood)),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Donation History',
                            style: AppTextStyles.boldStyle16,
                          ),
                          Image.asset(AppAssets.loadingIcon, width: 26),
                        ],
                      ),

                      const SizedBox(height: 12),
                      FutureBuilder<List<QueryDocumentSnapshot>>(
                        future: _getDonations(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final donations = snapshot.data!;

                          if (donations.isEmpty) {
                            return _buildEmptyDonationCard();
                          }

                          return Column(
                            children: donations.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;

                              final bloodType = data['bloodType'] ?? 'N/A';
                              final gender = data['gender'] ?? 'N/A';

                              String date = '';

                              if (data['createdAt'] != null) {
                                final createdAt =
                                    (data['createdAt'] as Timestamp).toDate();

                                date = DateFormat(
                                  'dd MMM yyyy',
                                ).format(createdAt);
                              }

                              return _buildDonationCard(
                                bloodType: bloodType,
                                gender: gender,
                                date: date,
                              );
                            }).toList(),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _menuItem(
                              context,
                              icon: AppAssets.change_PasswordIcon,
                              title: 'Change Password',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ChangePasswordScreen(),
                                  ),
                                );
                              },
                            ),
                            _divider(),
                            _menuItem(
                              context,
                              icon: AppAssets.dashBoardIcon,
                              title: 'Dashboard',
                              onTap: () async {
                                final Uri url = Uri.parse(
                                  'https://blood-bank-2d309.web.app/login.html?v=${DateTime.now().millisecondsSinceEpoch}',
                                );
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            ),
                            _divider(),
                            _menuItem(
                              context,
                              icon: AppAssets.logoutIcon,
                              title: 'Log Out',
                              isRed: true,
                              onTap: () async {
                                await AuthService().logout();
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.welcome,
                                    (route) => false,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required String icon,
    required String title,
    bool isRed = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Image.asset(icon, width: 24, height: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isRed ? Colors.red : Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Divider(color: Colors.grey.shade300, height: 1),
    );
  }

  Widget _buildDonationCard({
    required String bloodType,
    required String gender,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date: $date",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Blood Type: $bloodType",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 6),

          Text(
            "Gender: $gender",
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDonationCard() {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Donations",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text("No donations yet", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
