import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';

import 'package:blood_bank/core/constants/app_assets.dart';
import 'package:blood_bank/core/widgets/app_text_field.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import 'package:blood_bank/core/widgets/app_error_box.dart';
import 'package:blood_bank/core/constants/app_enums.dart';
import 'package:blood_bank/view_model/auth/signup_view_model.dart';
import 'package:blood_bank/view/home/home.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final SignupViewModel _viewModel = SignupViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelUpdate);
  }

  void _onViewModelUpdate() {
    if (!mounted) return;
    setState(() {});

    if (_viewModel.status == AuthStatus.success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelUpdate);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Row(
                children: [
                  const Text(
                    'Create Account ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Image.asset(AppAssets.bloodDrop, width: 24, height: 24),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Join us and start saving lives today',
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 32),

              AppTextField(
                hint: 'Full Name',
                prefixIcon: Icons.person_outline,
                controller: _viewModel.fullNameController,
              ),

              const SizedBox(height: 16),

              AppTextField(
                hint: 'Phone',
                prefixIcon: Icons.phone_outlined,
                controller: _viewModel.phoneController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              AppTextField(
                hint: 'Email',
                prefixIcon: Icons.email_outlined,
                controller: _viewModel.emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              AppTextField(
                hint: 'Address',
                prefixIcon: Icons.location_on_outlined,
                controller: _viewModel.addressController,
              ),

              const SizedBox(height: 16),

              AppTextField(
                hint: 'Blood Type',
                prefixIcon: Icons.bloodtype_outlined,
                controller: _viewModel.bloodTypeController,
              ),

              const SizedBox(height: 16),

              AppTextField(
                hint: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _viewModel.obscurePassword,
                controller: _viewModel.passwordController,
                suffixIcon: IconButton(
                  icon: Icon(
                    _viewModel.obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.grey,
                    size: 20,
                  ),
                  onPressed: _viewModel.togglePasswordVisibility,
                ),
              ),

              const SizedBox(height: 16),

              if (_viewModel.status == AuthStatus.error) ...[
                const SizedBox(height: 8),
                AppErrorBox(message: _viewModel.errorMessage),
                const SizedBox(height: 16),
              ],

              PrimaryButton(
                text: 'Sign Up',
                onPressed: _viewModel.signUp,
                isLoading: _viewModel.isLoading,
              ),

              const SizedBox(height: 16),

              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: AppTextStyles.body,
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
