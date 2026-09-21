// features/auth/presentation/cubits/auth_cubit/auth_states.dart
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {}

class LoginFailureState extends AuthState {}

class SignUpLoadingState extends AuthState {}

class SignUpSuccessState extends AuthState {}

class SignUpFailureState extends AuthState {
  final String error;

  SignUpFailureState({required this.error});
}

class LogoutLoadingState extends AuthState {}

class LogoutSuccessState extends AuthState {}

class LogoutFailureState extends AuthState {
  final String error;

  LogoutFailureState({required this.error});
}
