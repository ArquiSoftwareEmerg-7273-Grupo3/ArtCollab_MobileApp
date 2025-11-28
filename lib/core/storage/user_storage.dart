import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _userRoleKey = 'user_role';

  /// Save current user information
  Future<void> saveUser({
    required int userId,
    required String username,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_userRoleKey, role);
  }

  /// Get current user ID
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  /// Get current username
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  /// Get current user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  /// Clear user information
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_userRoleKey);
  }

  /// Check if user is logged in
  Future<bool> hasUser() async {
    final userId = await getUserId();
    return userId != null;
  }
}
