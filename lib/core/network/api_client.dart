import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';
import '../constants/app_constants.dart';

/// Centralized HTTP client with authentication and error handling
class ApiClient {
  final http.Client _client;
  final TokenStorage _tokenStorage;
  
  static const Duration _timeout = Duration(seconds: 30);

  ApiClient({
    http.Client? client,
    TokenStorage? tokenStorage,
  })  : _client = client ?? http.Client(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  /// Expose base URL for multipart requests
  String get baseUrl => AppConstants.authBaseUrl;

  /// Expose token storage for multipart requests
  TokenStorage get tokenStorage => _tokenStorage;

  /// Build headers with authentication if token exists
  Future<Map<String, String>> _buildHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await _tokenStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Handle HTTP errors and convert to user-friendly messages
  String _handleError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['error'] ?? 'An error occurred';
    } catch (e) {
      // If JSON parsing fails, return generic message based on status code
      if (response.statusCode >= 400 && response.statusCode < 500) {
        return 'Invalid request. Please check your input.';
      } else if (response.statusCode >= 500) {
        return 'Something went wrong on our end. Please try again later.';
      }
      return 'An unexpected error occurred';
    }
  }

  /// GET request
  Future<http.Response> get(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    try {
      final headers = await _buildHeaders(includeAuth: includeAuth);
      final uri = Uri.parse('${AppConstants.authBaseUrl}$endpoint');
      
      final response = await _client
          .get(uri, headers: headers)
          .timeout(_timeout);

      if (response.statusCode == 401) {
        // Clear token and throw authentication error
        await _tokenStorage.clearToken();
        throw Exception('Session expired. Please login again.');
      }

      return response;
    } on SocketException {
      throw Exception('Unable to connect. Please check your internet connection.');
    } on http.ClientException {
      throw Exception('Unable to connect. Please check your internet connection.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  /// POST request
  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool includeAuth = true,
  }) async {
    try {
      final headers = await _buildHeaders(includeAuth: includeAuth);
      final uri = Uri.parse('${AppConstants.authBaseUrl}$endpoint');
      
      final response = await _client
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);

      if (response.statusCode == 401) {
        await _tokenStorage.clearToken();
        throw Exception('Session expired. Please login again.');
      }

      return response;
    } on SocketException {
      throw Exception('Unable to connect. Please check your internet connection.');
    } on http.ClientException {
      throw Exception('Unable to connect. Please check your internet connection.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  /// PUT request
  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool includeAuth = true,
  }) async {
    try {
      final headers = await _buildHeaders(includeAuth: includeAuth);
      final uri = Uri.parse('${AppConstants.authBaseUrl}$endpoint');
      
      final response = await _client
          .put(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);

      if (response.statusCode == 401) {
        await _tokenStorage.clearToken();
        throw Exception('Session expired. Please login again.');
      }

      return response;
    } on SocketException {
      throw Exception('Unable to connect. Please check your internet connection.');
    } on http.ClientException {
      throw Exception('Unable to connect. Please check your internet connection.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  /// DELETE request
  Future<http.Response> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    try {
      final headers = await _buildHeaders(includeAuth: includeAuth);
      final uri = Uri.parse('${AppConstants.authBaseUrl}$endpoint');
      
      final response = await _client
          .delete(uri, headers: headers)
          .timeout(_timeout);

      if (response.statusCode == 401) {
        await _tokenStorage.clearToken();
        throw Exception('Session expired. Please login again.');
      }

      return response;
    } on SocketException {
      throw Exception('Unable to connect. Please check your internet connection.');
    } on http.ClientException {
      throw Exception('Unable to connect. Please check your internet connection.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  /// PATCH request
  Future<http.Response> patch(
    String endpoint,
    Map<String, dynamic> body, {
    bool includeAuth = true,
  }) async {
    try {
      final headers = await _buildHeaders(includeAuth: includeAuth);
      final uri = Uri.parse('${AppConstants.authBaseUrl}$endpoint');
      
      final response = await _client
          .patch(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);

      if (response.statusCode == 401) {
        await _tokenStorage.clearToken();
        throw Exception('Session expired. Please login again.');
      }

      return response;
    } on SocketException {
      throw Exception('Unable to connect. Please check your internet connection.');
    } on http.ClientException {
      throw Exception('Unable to connect. Please check your internet connection.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  /// Close the HTTP client
  void close() {
    _client.close();
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}
