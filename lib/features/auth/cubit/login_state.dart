import 'package:blood_bank/core/constants/app_enums.dart';

class LoginState {
  final AuthStatus status;
  final String errorMessage;
  final bool obscurePassword;

  const LoginState({
    this.status = AuthStatus.idle,
    this.errorMessage = '',
    this.obscurePassword = true,
  });

  LoginState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool? obscurePassword,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}
