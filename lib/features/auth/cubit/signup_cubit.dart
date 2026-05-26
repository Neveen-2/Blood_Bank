import 'package:bloc/bloc.dart';
import 'package:blood_bank/core/constants/app_enums.dart';
import 'package:blood_bank/features/auth/services/auth_service.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthService _service;

  SignupCubit({AuthService? service})
    : _service = service ?? AuthService(),
      super(const SignupState());

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> signUp({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    required String bloodType,
    required String password,
    required String role,
  }) async {
    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        address.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Please fill all required fields',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, errorMessage: ''));
    try {
      await _service.signup(
        fullName: fullName,
        phone: phone,
        email: email,
        address: address,
        bloodType: bloodType,
        password: password,
        role: role,
      );
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      final message = e.toString();
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: message.contains('email-already-in-use')
              ? 'Email already exists'
              : message.contains('weak-password')
              ? 'Weak password'
              : message.contains('Invalid address')
              ? 'Invalid address, please enter a correct location'
              : 'Signup failed',
        ),
      );
    }
  }
}
