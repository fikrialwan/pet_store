import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(AuthUserModel user);
  Future<AuthUserModel?> getUser();
  Future<void> removeUser();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _usernameKey = 'auth_username';
  static const String _emailKey = 'auth_email';
  static const String _firstNameKey = 'auth_first_name';
  static const String _lastNameKey = 'auth_last_name';
  static const String _expiresAtKey = 'auth_expires_at';

  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveUser(AuthUserModel user) async {
    await sharedPreferences.setString(_usernameKey, user.username);
    if (user.email != null) {
      await sharedPreferences.setString(_emailKey, user.email!);
    }
    if (user.firstName != null) {
      await sharedPreferences.setString(_firstNameKey, user.firstName!);
    }
    if (user.lastName != null) {
      await sharedPreferences.setString(_lastNameKey, user.lastName!);
    }
    await sharedPreferences.setString(
      _expiresAtKey,
      user.expiresAt.toIso8601String(),
    );
  }

  @override
  Future<AuthUserModel?> getUser() async {
    final username = sharedPreferences.getString(_usernameKey);
    final email = sharedPreferences.getString(_emailKey);
    final firstName = sharedPreferences.getString(_firstNameKey);
    final lastName = sharedPreferences.getString(_lastNameKey);
    final expiresAtString = sharedPreferences.getString(_expiresAtKey);

    if (username == null || expiresAtString == null) return null;

    final expiresAt = DateTime.parse(expiresAtString);

    // Check if user data is expired
    if (DateTime.now().isAfter(expiresAt)) {
      await removeUser();
      return null;
    }

    return AuthUserModel(
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      expiresAt: expiresAt,
    );
  }

  @override
  Future<void> removeUser() async {
    await sharedPreferences.remove(_usernameKey);
    await sharedPreferences.remove(_emailKey);
    await sharedPreferences.remove(_firstNameKey);
    await sharedPreferences.remove(_lastNameKey);
    await sharedPreferences.remove(_expiresAtKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null && !user.isExpired;
  }
}