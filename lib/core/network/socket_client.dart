import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants/app_constants.dart';

/// Socket.IO client for real-time communication
class SocketClient {
  IO.Socket? _socket;
  String? _currentToken;

  /// Check if socket is connected
  bool get isConnected => _socket?.connected ?? false;

  /// Connect to Socket.IO server with authentication token
  void connect(String token) {
    _currentToken = token;
    
    // Close existing connection if any
    if (_socket != null) {
      _socket!.dispose();
    }

    // Create socket connection with authentication
    _socket = IO.io(
      AppConstants.authBaseUrl.replaceAll('/api/v1/', ''),
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .setAuth({'token': 'Bearer $token'})
          .build(),
    );

    // Connection event handlers
    _socket!.onConnect((_) {
      print('✅ Socket.IO connected');
    });

    _socket!.onDisconnect((_) {
      print('❌ Socket.IO disconnected');
    });

    _socket!.onConnectError((error) {
      print('🔴 Socket.IO connection error: $error');
    });

    _socket!.onError((error) {
      print('🔴 Socket.IO error: $error');
    });

    _socket!.onReconnect((attempt) {
      print('🔄 Socket.IO reconnected (attempt $attempt)');
    });

    _socket!.onReconnectAttempt((attempt) {
      print('🔄 Socket.IO reconnection attempt $attempt');
    });

    _socket!.onReconnectError((error) {
      print('🔴 Socket.IO reconnection error: $error');
    });

    _socket!.onReconnectFailed((_) {
      print('🔴 Socket.IO reconnection failed');
    });
  }

  /// Disconnect from Socket.IO server
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _currentToken = null;
      print('🔌 Socket.IO disconnected manually');
    }
  }

  /// Listen for events from server
  void on(String event, Function(dynamic) callback) {
    if (_socket == null) {
      print('⚠️ Socket not initialized. Call connect() first.');
      return;
    }
    _socket!.on(event, callback);
  }

  /// Remove event listener
  void off(String event) {
    if (_socket == null) {
      return;
    }
    _socket!.off(event);
  }

  /// Emit event to server
  void emit(String event, dynamic data) {
    if (_socket == null) {
      print('⚠️ Socket not initialized. Call connect() first.');
      return;
    }
    
    if (!isConnected) {
      print('⚠️ Socket not connected. Event "$event" not sent.');
      return;
    }

    _socket!.emit(event, data);
  }

  /// Emit event with acknowledgment
  void emitWithAck(String event, dynamic data, Function(dynamic) ack) {
    if (_socket == null) {
      print('⚠️ Socket not initialized. Call connect() first.');
      return;
    }
    
    if (!isConnected) {
      print('⚠️ Socket not connected. Event "$event" not sent.');
      return;
    }

    _socket!.emitWithAck(event, data, ack: ack);
  }

  /// Dispose socket connection
  void dispose() {
    disconnect();
  }
}
