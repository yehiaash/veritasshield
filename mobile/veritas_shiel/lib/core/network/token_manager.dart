import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [TokenManager] handles the storage and retrieval of authentication tokens
/// and user preferences like 'Remember Me' and 'First Time' status.
class TokenManager {
  // Secure storage for sensitive data like JWT tokens
  static const _storage = FlutterSecureStorage();

  // Keys for storage
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _rememberMeKey = 'remember_me';
  static const _isFirstTimeKey = 'is_first_time';

  /// Saves both JWT tokens securely and the 'Remember Me' preference.
  static Future<void> saveTokens(
    String access,
    String refresh,
    bool rememberMe,
  ) async {
    // Encrypt and save access token
    await _storage.write(key: _accessTokenKey, value: access);
    // Encrypt and save refresh token
    await _storage.write(key: _refreshTokenKey, value: refresh);

    // Save the user's preference for staying logged in
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);
  }

  /// Checks if the app is being opened for the first time.
  /// Returns [true] if no record is found.
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstTimeKey) ?? true;
  }

  /// Sets the 'First Time' flag to [false] after the user completes onboarding.
  static Future<void> setFirstTimeDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstTimeKey, false);
  }

  /// Retrieves the saved access token from secure storage.
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Retrieves the saved refresh token from secure storage.
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Checks if the user previously selected 'Remember Me'.
  static Future<bool> shouldRemember() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  /// Clears all saved tokens and resets the 'Remember Me' preference.
  /// Typically called during logout.
  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, false);
  }
}
