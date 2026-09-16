// features/auth/presentation/cubits/auth_cubit/auth_states.dart
abstract class AuthState {}

 class AuthInitialState extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {}

class LoginFailureState extends AuthState {}
