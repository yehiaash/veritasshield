import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/token_manager.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login(String email, String password, bool rememberMe) async {
    emit(AuthLoading());
    final result = await _authRepository.login(email: email, password: password);
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (tokenResponse) async {
        await TokenManager.saveTokens(tokenResponse.access, tokenResponse.refresh, rememberMe);
        emit(AuthSuccess(tokenResponse));
      },
    );
  }

  Future<void> signUp(String name, String email, String password) async {
    emit(AuthLoading());
    final result = await _authRepository.register(name: name, email: email, password: password);
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (tokenResponse) async {
        // Sign up usually remembers by default
        await TokenManager.saveTokens(tokenResponse.access, tokenResponse.refresh, true);
        emit(AuthSuccess(tokenResponse));
      },
    );
  }
}
