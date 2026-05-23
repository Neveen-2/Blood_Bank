import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_enums.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';
import 'package:blood_bank/core/constants/app_routes.dart';
import 'package:blood_bank/core/widgets/app_error_box.dart';
import 'package:blood_bank/core/widgets/app_text_field.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
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
                    AppTextField(
                      hint: 'someone@gmail.com',
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      hint: 'Enter your password',
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
                    if (state.status == AuthStatus.error) ...[
                      const SizedBox(height: 8),
                      AppErrorBox(message: state.errorMessage),
                    ],
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Login',
                      onPressed: () {
                        cubit.login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      },
                      isLoading: state.status == AuthStatus.loading,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: AppTextStyles.body,
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.signup,
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
        },
      ),
    );
  }
}
