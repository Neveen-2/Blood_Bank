import 'package:bloc/bloc.dart';
import 'package:blood_bank/core/constants/app_enums.dart';
import 'package:blood_bank/features/auth/services/auth_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _service;

  LoginCubit({AuthService? service})
    : _service = service ?? AuthService(),
      super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> login({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Please fill all fields',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, errorMessage: ''));
    try {
      await _service.login(email: email, password: password);
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.toString().contains('user-not-found')
              ? 'No user found for that email'
              : e.toString().contains('wrong-password')
              ? 'Wrong password'
              : e.toString().contains('invalid-email')
              ? 'Invalid email'
              : 'Login failed',
        ),
      );
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    if (email.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Please enter your email',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, errorMessage: ''));
    try {
      await _service.sendPasswordResetEmail(email: email);
      emit(
        state.copyWith(
          status: AuthStatus.success,
          isForgotPasswordSent: true,
          errorMessage: 'Password reset email sent successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
