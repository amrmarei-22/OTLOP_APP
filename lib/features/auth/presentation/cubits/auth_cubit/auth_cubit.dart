// features/auth/presentation/cubits/auth_cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();
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
}
