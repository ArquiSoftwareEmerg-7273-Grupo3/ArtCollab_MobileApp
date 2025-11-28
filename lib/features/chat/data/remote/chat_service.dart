import 'dart:convert';
import 'dart:io';
import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';

class ChatService {
  final ApiClient _apiClient;

  ChatService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// GET /api/v1/chats - Obtener todos los chats
  Future<Resource<List<ChatDto>>> getAllChats() async {
    try {
      final response = await _apiClient.get('chats');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final chats = json.map((e) => ChatDto.fromJson(e)).toList();
        return Success(chats);
      }
      return Error('Error al cargar los chats');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// POST /api/v1/chats - Crear un nuevo chat
  Future<Resource<ChatDto>> createChat(int usuario1id, int usuario2id) async {
    try {
      final response = await _apiClient.post('chats', {
        'usuario1id': usuario1id,
        'usuario2id': usuario2id,
      });
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Success(ChatDto.fromJson(json));
      }
      return Error('Error al crear el chat');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/chats/{chatId} - Obtener un chat por ID
  Future<Resource<ChatDto>> getChatById(int chatId) async {
    try {
      final response = await _apiClient.get('chats/$chatId');
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Success(ChatDto.fromJson(json));
      }
      return Error('Error al cargar el chat');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/chats/{chatId}/mensajes - Obtener mensajes de un chat
  Future<Resource<List<MessageDto>>> getMessages(int chatId) async {
    try {
      final response = await _apiClient.get('chats/$chatId/mensajes');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final messages = json.map((e) => MessageDto.fromJson(e)).toList();
        return Success(messages);
      }
      return Error('Error al cargar los mensajes');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// POST /api/v1/chats/{chatId}/mensajes - Enviar un mensaje
  Future<Resource<void>> sendMessage(int chatId, int remitenteId, String texto) async {
    try {
      final response = await _apiClient.post('chats/$chatId/mensajes', {
        'remitenteId': remitenteId,
        'texto': texto,
      });
      if (response.statusCode == HttpStatus.ok) {
        return Success(null);
      }
      return Error('Error al enviar el mensaje');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/chats/mensajes/receptor/{remitenteId} - Obtener receptores por remitente
  Future<Resource<List<MessageDto>>> getMessagesByRemitente(int remitenteId) async {
    try {
      final response = await _apiClient.get('chats/mensajes/receptor/$remitenteId');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final messages = json.map((e) => MessageDto.fromJson(e)).toList();
        return Success(messages);
      }
      return Error('Error al cargar los mensajes del remitente');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }
}

class ChatDto {
  final int id;
  final int usuario1id;
  final int usuario2id;
  final bool estado;

  ChatDto({
    required this.id,
    required this.usuario1id,
    required this.usuario2id,
    required this.estado,
  });

  factory ChatDto.fromJson(Map<String, dynamic> json) {
    return ChatDto(
      id: json['id'] ?? 0,
      usuario1id: json['usuario1id'] ?? 0,
      usuario2id: json['usuario2id'] ?? 0,
      estado: json['estado'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario1id': usuario1id,
      'usuario2id': usuario2id,
      'estado': estado,
    };
  }
}

class MessageDto {
  final int id;
  final int chatId;
  final int remitenteId;
  final String texto;

  MessageDto({
    required this.id,
    required this.chatId,
    required this.remitenteId,
    required this.texto,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      id: json['id'] ?? 0,
      chatId: json['chatId'] ?? 0,
      remitenteId: json['remitenteId'] ?? 0,
      texto: json['texto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'remitenteId': remitenteId,
      'texto': texto,
    };
  }
}
