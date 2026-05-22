import 'package:blood_bank/view/profile/change_password.dart';
import 'package:flutter/material.dart';
import '../../view/home/home.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

import '../../core/widgets/profile_data_field.dart';
import '../../core/widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileDataField(
                    label: "Username", 
                    hint: "yANCHUI"),
                  const ProfileDataField(
                    label: "Email",
                    hint: "your@gmail.com",
                  ),
                  const ProfileDataField(
                    label: "Phone Number",
                    hint: "+0123456789",
                  ),
                  const ProfileDataField(label: "Blood type", hint: "A-"),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My Donation History",
                        style: AppTextStyles.boldStyle16,
                      ),
                      Image.asset(AppAssets.loadingIcon, width: 30),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDonationCard(),

                  const SizedBox(height: 35),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: AppAssets.change_PasswordIcon,
                          title: "Change Password",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChangePassword(),
                              ),
                            );
                          },
                        ),

                        ProfileMenuItem(
                          icon: AppAssets.dashBoardIcon,
                          title: "Dashboard",
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: AppAssets.logoutIcon,
                          title: "Log Out",
                          isRed: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.22,
          width: double.infinity,
          color: AppColors.primary,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Profile",
                      style: AppTextStyles.font18WhiteBold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(AppAssets.u_share_altIcon, width: 21),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          child: CircleAvatar(
            radius: 64,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(AppAssets.photo),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDonationCard() {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
