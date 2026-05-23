import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_assets.dart';
import 'package:blood_bank/core/widgets/home_bottom_nav.dart';
import 'package:blood_bank/core/widgets/home_header.dart';
import '../../blood/screens/select_blood_group_screen.dart';
import '../../emergency/screens/emergency_screen.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildOverview(context),
      EmergencyScreen(onBackToHome: () => _setIndex(0)),
      const SelectBloodGroupScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: screens[_selectedIndex],
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: _selectedIndex,
        onTap: _setIndex,
      ),
    );
  }

  Widget _buildOverview(BuildContext context) {
    return Column(
      children: [
        const HomeHeader(userName: 'Donor'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickActions(context),
                  const SizedBox(height: 20),
                  _buildNearbyDonorsSection(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'label': 'Donor', 'asset': AppAssets.donorIcon},
      {'label': 'Blood Bank', 'asset': AppAssets.bloodBankIcon},
      {'label': 'Location', 'asset': AppAssets.locationIcon},
      {'label': 'Emergency', 'asset': AppAssets.emergencyIcon},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: actions.map((action) {
        return GestureDetector(
          onTap: () {
            if (action['label'] == 'Emergency') {
              _setIndex(1);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  action['asset']!,
                  width: 52,
                  height: 52,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Text(
                  action['label']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNearbyDonorsSection(BuildContext context) {
    final donors = [
      {'name': 'Sara Ali', 'blood': 'A-', 'distance': '2.4km'},
      {'name': 'Omar Adel', 'blood': 'B+', 'distance': '3.1km'},
      {'name': 'Mina Fathy', 'blood': 'O-', 'distance': '4.0km'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nearby Donors',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            TextButton(
              onPressed: () {
                _setIndex(2);
              },
              child: const Text(
                'View All',
                style: TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...donors.map((donor) => _donorCard(donor)),
      ],
    );
  }

  Widget _donorCard(Map<String, String> donor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                donor['blood']!,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donor['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 12,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      donor['distance']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Contact',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
