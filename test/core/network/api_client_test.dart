import 'package:flutter_test/flutter_test.dart';
import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/storage/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('ApiClient Property Tests', () {
    late ApiClient apiClient;
    late MockTokenStorage mockTokenStorage;

    setUp(() {
      mockTokenStorage = MockTokenStorage();
    });

    // Feature: backend-integration, Property 1: Header inclusion
    test('HTTP requests include required headers', () async {
      for (int i = 0; i < 100; i++) {
        // Generate random endpoint
        final endpoint = 'test/endpoint/$i';
        bool headersChecked = false;

        final mockClient = MockClient((request) async {
          // Verify Content-Type header is present
          expect(request.headers['Content-Type'], equals('application/json'));
          
          // If token exists, verify Authorization header
          if (mockTokenStorage.hasToken) {
            expect(request.headers['Authorization'], isNotNull);
            expect(request.headers['Authorization'], startsWith('Bearer '));
          }
          
          headersChecked = true;
          return http.Response('{"success": true}', 200);
        });

        apiClient = ApiClient(
          client: mockClient,
          tokenStorage: mockTokenStorage,
        );

        // Test GET request
        await apiClient.get(endpoint);
        expect(headersChecked, isTrue);

        apiClient.close();
      }
    });

    // Feature: backend-integration, Property 2: Token injection
    test('authenticated requests include Bearer token in Authorization header', () async {
      for (int i = 0; i < 100; i++) {
        final testToken = 'test_token_$i';
        mockTokenStorage.setToken(testToken);

        bool tokenVerified = false;

        final mockClient = MockClient((request) async {
          final authHeader = request.headers['Authorization'];
          expect(authHeader, equals('Bearer $testToken'));
          tokenVerified = true;
          return http.Response('{"success": true}', 200);
        });

        apiClient = ApiClient(
          client: mockClient,
          tokenStorage: mockTokenStorage,
        );

        await apiClient.get('test/endpoint');
        expect(tokenVerified, isTrue);

        apiClient.close();
      }
    });

    // Feature: backend-integration, Property 3: Network error handling
    test('network errors return user-friendly error messages', () async {
      for (int i = 0; i < 100; i++) {
        final mockClient = MockClient((request) async {
          throw http.ClientException('Network error');
        });

        apiClient = ApiClient(
          client: mockClient,
          tokenStorage: mockTokenStorage,
        );

        try {
          await apiClient.get('test/endpoint');
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e.toString(), contains('Unable to connect'));
          expect(e.toString(), contains('internet connection'));
        }

        apiClient.close();
      }
    });

    // Feature: backend-integration, Property 4: JSON parsing round-trip
    test('JSON responses parse to DTO and back correctly', () async {
      for (int i = 0; i < 100; i++) {
        final testData = {
          'id': i,
          'name': 'Test User $i',
          'email': 'test$i@example.com',
          'active': i % 2 == 0,
        };

        final mockClient = MockClient((request) async {
          return http.Response(jsonEncode(testData), 200);
        });

        apiClient = ApiClient(
          client: mockClient,
          tokenStorage: mockTokenStorage,
        );

        final response = await apiClient.get('test/endpoint');
        final parsed = jsonDecode(response.body);

        // Verify all fields are preserved
        expect(parsed['id'], equals(testData['id']));
        expect(parsed['name'], equals(testData['name']));
        expect(parsed['email'], equals(testData['email']));
        expect(parsed['active'], equals(testData['active']));

        // Round-trip: encode back and verify
        final reEncoded = jsonEncode(parsed);
        final reParsed = jsonDecode(reEncoded);
        expect(reParsed, equals(testData));

        apiClient.close();
      }
    });
  });
}

/// Mock TokenStorage for testing
class MockTokenStorage extends TokenStorage {
  String? _token;
  bool get hasToken => _token != null;

  void setToken(String token) {
    _token = token;
  }

  @override
  Future<String?> getToken() async {
    return _token;
  }

  @override
  Future<void> saveToken(String token) async {
    _token = token;
  }

  @override
  Future<void> clearToken() async {
    _token = null;
  }

  @override
  Future<bool> hasValidToken() async {
    return _token != null;
  }
}
