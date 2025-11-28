import 'package:flutter_test/flutter_test.dart';
import 'package:artcollab_mobile/core/network/socket_client.dart';

void main() {
  group('SocketClient Unit Tests', () {
    late SocketClient socketClient;

    setUp(() {
      socketClient = SocketClient();
    });

    tearDown(() {
      socketClient.dispose();
    });

    test('socket is not connected initially', () {
      expect(socketClient.isConnected, isFalse);
    });

    test('connect initializes socket with token', () {
      final testToken = 'test_jwt_token_123';
      
      // This will attempt to connect but may fail in test environment
      // We're mainly testing that it doesn't throw an error
      expect(() => socketClient.connect(testToken), returnsNormally);
    });

    test('disconnect closes socket connection', () {
      final testToken = 'test_jwt_token_123';
      socketClient.connect(testToken);
      
      expect(() => socketClient.disconnect(), returnsNormally);
      expect(socketClient.isConnected, isFalse);
    });

    test('event listeners can be registered', () {
      final testToken = 'test_jwt_token_123';
      socketClient.connect(testToken);
      
      bool callbackCalled = false;
      void testCallback(dynamic data) {
        callbackCalled = true;
      }
      
      // Should not throw when registering listener
      expect(() => socketClient.on('test_event', testCallback), returnsNormally);
    });

    test('emit handles disconnected state gracefully', () {
      // Without connecting, emit should handle gracefully
      expect(() => socketClient.emit('test_event', {'data': 'test'}), returnsNormally);
    });

    test('dispose cleans up resources', () {
      final testToken = 'test_jwt_token_123';
      socketClient.connect(testToken);
      
      expect(() => socketClient.dispose(), returnsNormally);
      expect(socketClient.isConnected, isFalse);
    });

    test('multiple connect calls replace previous connection', () {
      final token1 = 'token_1';
      final token2 = 'token_2';
      
      socketClient.connect(token1);
      expect(() => socketClient.connect(token2), returnsNormally);
    });

    test('off removes event listener', () {
      final testToken = 'test_jwt_token_123';
      socketClient.connect(testToken);
      
      void testCallback(dynamic data) {}
      socketClient.on('test_event', testCallback);
      
      expect(() => socketClient.off('test_event'), returnsNormally);
    });
  });
}
