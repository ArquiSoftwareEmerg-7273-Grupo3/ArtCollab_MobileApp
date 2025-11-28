import 'package:shared_preferences/shared_preferences.dart';

/// Secure storage for JWT tokens
class TokenStorage {
  static const String _tokenKey = 'jwt_token';
  static const String _tokenExpiryKey = 'jwt_token_expiry';

  /// Save JWT token to storage
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    
    // Store expiry time (tokens typically expire in 24 hours)
    final expiryTime = DateTime.now().add(const Duration(hours: 24));
    await prefs.setInt(_tokenExpiryKey, expiryTime.millisecondsSinceEpoch);
  }

  /// Retrieve JWT token from storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Clear JWT token from storage
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenExpiryKey);
  }

  /// Check if a valid token exists
  Future<bool> hasValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    
    if (token == null) {
      return false;
    }

    // Check if token has expired
    final expiryTimestamp = prefs.getInt(_tokenExpiryKey);
    if (expiryTimestamp == null) {
      return false;
    }

    final expiryTime = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
    return DateTime.now().isBefore(expiryTime);
  }
}
