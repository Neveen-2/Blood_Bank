import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_enums.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';
import 'package:blood_bank/core/constants/app_routes.dart';
import 'package:blood_bank/core/widgets/app_error_box.dart';
import 'package:blood_bank/core/widgets/app_text_field.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import '../cubit/signup_cubit.dart';
import '../cubit/signup_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _bloodTypeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        },
        builder: (context, state) {
          final cubit = context.read<SignupCubit>();
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.black),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your account to start saving lives and donating blood.',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    hint: 'Full Name',
                    prefixIcon: Icons.person_outline,
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    hint: 'Phone Number',
                    prefixIcon: Icons.phone_outlined,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    hint: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    hint: 'Address',
                    prefixIcon: Icons.location_on_outlined,
                    controller: _addressController,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    hint: 'Blood Type',
                    prefixIcon: Icons.bloodtype_outlined,
                    controller: _bloodTypeController,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    hint: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: state.obscurePassword,
                    controller: _passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey,
                        size: 20,
                      ),
                      onPressed: cubit.togglePasswordVisibility,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.status == AuthStatus.error) ...[
                    AppErrorBox(message: state.errorMessage),
                    const SizedBox(height: 12),
                  ],
                  PrimaryButton(
                    text: 'Sign Up',
                    onPressed: () {
                      cubit.signUp(
                        fullName: _fullNameController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                        address: _addressController.text,
                        bloodType: _bloodTypeController.text,
                        password: _passwordController.text,
                      );
                    },
                    isLoading: state.status == AuthStatus.loading,
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
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                );
                              },
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
          );
        },
      ),
    );
  }
}
