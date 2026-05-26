import 'package:blood_bank/core/constants/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';
import 'package:blood_bank/core/constants/app_routes.dart';
import 'package:blood_bank/core/widgets/app_error_box.dart';
import 'package:blood_bank/core/widgets/app_text_field.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import 'package:blood_bank/core/widgets/app_dropdown.dart';
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

  String? _selectedRole;

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

  Widget _gap() => const SizedBox(height: 12);

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
            body: SafeArea(
              child: SingleChildScrollView(
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

                    const SizedBox(height: 6),

                    Text(
                      'Join us and start saving lives today',
                      style: AppTextStyles.body.copyWith(fontSize: 13),
                    ),

                    const SizedBox(height: 22),

                    AppTextField(
                      hint: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      controller: _fullNameController,
                    ),

                    _gap(),

                    AppTextField(
                      hint: 'Phone',
                      prefixIcon: Icons.phone_outlined,
                      controller: _phoneController,
                    ),

                    _gap(),

                    AppTextField(
                      hint: 'Email',
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                    ),

                    _gap(),

                    AppTextField(
                      hint: 'Address',
                      prefixIcon: Icons.location_on_outlined,
                      controller: _addressController,
                    ),

                    _gap(),

                    AppTextField(
                      hint: 'Blood Type',
                      prefixIcon: Icons.bloodtype_outlined,
                      controller: _bloodTypeController,
                    ),

                    _gap(),

                    AppDropdown<String>(
                      selectedValue: _selectedRole,
                      items: const ['user', 'admin'],
                      hint: 'Choose Role',
                      icon: Icons.person_outline,
                      itemLabel: (e) => e == 'admin' ? 'Admin' : 'User',
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                    ),

                    _gap(),

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
                        ),
                        onPressed: cubit.togglePasswordVisibility,
                      ),
                    ),

                    const SizedBox(height: 18),

                    if (state.status == AuthStatus.error)
                      AppErrorBox(message: state.errorMessage),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: PrimaryButton(
                        text: 'Sign Up',
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          cubit.signUp(
                            fullName: _fullNameController.text,
                            phone: _phoneController.text,
                            email: _emailController.text,
                            address: _addressController.text,
                            bloodType: _bloodTypeController.text,
                            password: _passwordController.text,
                            role: _selectedRole ?? 'user',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}