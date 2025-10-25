import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_user.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.username,
    super.email,
    super.firstName,
    super.lastName,
    required super.expiresAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  AuthUser toEntity() {
    return AuthUser(
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      expiresAt: expiresAt,
    );
  }

  factory AuthUserModel.fromEntity(AuthUser user) {
    return AuthUserModel(
      username: user.username,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      expiresAt: user.expiresAt,
    );
  }

  // Create from login response - token is stored separately
  factory AuthUserModel.fromLoginResponse({
    required String username,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    return AuthUserModel(
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      expiresAt: DateTime.now().add(const Duration(hours: 24)), // 24 hour expiry
    );
  }
}