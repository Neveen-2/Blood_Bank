import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';

import 'package:blood_bank/core/widgets/app_text_field.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import 'package:blood_bank/core/widgets/app_error_box.dart';
import 'package:blood_bank/core/constants/app_enums.dart';
import 'package:blood_bank/view_model/auth/login_view_model.dart';
import 'package:blood_bank/view/auth/signup.dart';
import 'package:blood_bank/view/home/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel _viewModel = LoginViewModel();

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
              const SizedBox(height: 20),

              // Header
              Row(
                children: const [
                  Text(
                    'Welcome Back ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text('🔥', style: TextStyle(fontSize: 22)),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Sign in to continue donating and saving lives',
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 40),

              // Email
              AppTextField(
                hint: 'someone@gmail.com',
                prefixIcon: Icons.email_outlined,
                controller: _viewModel.emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // Password
              AppTextField(
                hint: 'Enter your password',
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

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Error
              if (_viewModel.status == AuthStatus.error) ...[
                const SizedBox(height: 8),
                AppErrorBox(message: _viewModel.errorMessage),
              ],

              const SizedBox(height: 32),

              // Login Button
              PrimaryButton(
                text: 'Login',
                onPressed: _viewModel.login,
                isLoading: _viewModel.isLoading,
              ),

              const SizedBox(height: 16),

              // Signup
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: AppTextStyles.body,
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Signup()),
                            );
                          },
                          child: const Text(
                            'Sign Up',
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
