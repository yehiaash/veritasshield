import 'package:equatable/equatable.dart';
import '../../data/models/token_response.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final TokenResponse tokenResponse;
  const AuthSuccess(this.tokenResponse);

  @override
  List<Object?> get props => [tokenResponse];
}

class AuthFailureState extends AuthState {
  final String message;
  const AuthFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
