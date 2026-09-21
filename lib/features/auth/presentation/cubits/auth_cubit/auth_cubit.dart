// features/auth/presentation/cubits/auth_cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/features/auth/data/auth_session.dart';
import 'package:otlop_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(SignUpLoadingState());
    try {
      await authRemoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      emit(SignUpSuccessState());
    } catch (error) {
      emit(SignUpFailureState(error: error.toString()));
    }
  }

  Future<void> login({required String email, required String pass}) async {
    emit(LoginLoadingState());
    await authRemoteDataSource
        .login(email: email, pass: pass)
        .then(
          onError: (err) {
            emit(LoginFailureState());
          },
          (val) {
            emit(LoginSuccessState());
          },
        );
  }

  Future<void> logout() async {
    emit(LogoutLoadingState());
    try {
      await AuthSession.clearAccessToken();
      emit(LogoutSuccessState());
    } catch (error) {
      emit(LogoutFailureState(error: error.toString()));
    }
  }
}
