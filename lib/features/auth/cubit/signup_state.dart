import 'package:blood_bank/core/constants/app_enums.dart';

class SignupState {
  final AuthStatus status;
  final String errorMessage;
  final bool obscurePassword;

  const SignupState({
    this.status = AuthStatus.idle,
    this.errorMessage = '',
    this.obscurePassword = true,
  });

  SignupState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool? obscurePassword,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}
