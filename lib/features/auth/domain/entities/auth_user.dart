import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final DateTime expiresAt;

  const AuthUser({
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [
        username,
        email,
        firstName,
        lastName,
        expiresAt,
      ];

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  AuthUser copyWith({
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    DateTime? expiresAt,
  }) {
    return AuthUser(
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}