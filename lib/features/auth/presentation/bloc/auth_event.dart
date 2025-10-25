import 'package:equatable/equatable.dart';
import '../../domain/entities/login_credentials.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final LoginCredentials credentials;

  const LoginRequested({required this.credentials});

  @override
  List<Object> get props => [credentials];
}

class LogoutRequested extends AuthEvent {}

class AuthStatusRequested extends AuthEvent {}

class AppStarted extends AuthEvent {}