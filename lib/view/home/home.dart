import 'package:blood_bank/view/blood/select_blood_group.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/core/widgets/home_body.dart';
import 'package:blood_bank/core/widgets/home_bottom_nav.dart';
import 'package:blood_bank/core/widgets/home_header.dart';
import 'package:blood_bank/view/emergency/emergency.dart';
import 'package:blood_bank/view/profile/profile.dart';
import 'package:blood_bank/view_model/home/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel viewModel = HomeViewModel();
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    //viewModel.loadNearbyDonors();
    viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      Column(
        children: [
          HomeHeader(userName: viewModel.userName),
          Expanded(child: HomeBody(viewModel: viewModel)),
        ],
      ),
      EmergencyScreen(
        onBackToHome: () {
          setState(() {
            selectedIndex = 0;
          });
        },
      ),
      const SelectBloodGroupView(),
      const ProfileScreen(),
    ];
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
