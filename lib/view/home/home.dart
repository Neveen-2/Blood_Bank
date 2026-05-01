import 'package:flutter/material.dart';
import 'package:graduation_project/core/widgets/home_body.dart';
import 'package:graduation_project/core/widgets/home_bottom_nav.dart';
import 'package:graduation_project/core/widgets/home_header.dart';
import 'package:graduation_project/view/blood/blood.dart';
import 'package:graduation_project/view/emergency/emergency.dart';
import 'package:graduation_project/view/profile/profile.dart';
import 'package:graduation_project/view_model/home/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel viewModel = HomeViewModel();
  int selectedIndex = 0;

  late final List<Widget> screens = [
    Column(
      children: [
        HomeHeader(
          userName: viewModel.userName,
        ),
        Expanded(
          child: HomeBody(viewModel: viewModel),
        ),
      ],
    ),
    EmergencyScreen(
      onBackToHome: () {
        setState(() {
          selectedIndex = 0;
        });
      },
    ),
    const BloodScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: screens[selectedIndex],
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}