import 'dart:convert';
import 'dart:io';
import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';

class UserService {
  final ApiClient _apiClient;
  
  // Cache para evitar múltiples requests del mismo usuario
  final Map<int, UserProfileDto> _usersCache = {};

  UserService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// GET /api/v1/users/{userId} - Obtener perfil de usuario por ID
  Future<Resource<UserProfileDto>> getUserById(int userId) async {
    // Verificar cache primero
    if (_usersCache.containsKey(userId)) {
      return Success(_usersCache[userId]!);
    }

    try {
      final response = await _apiClient.get('users/$userId');
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        final user = UserProfileDto.fromJson(json);
        
        // Guardar en cache
        _usersCache[userId] = user;
        
        return Success(user);
      }
      
      // En caso de error, devolver un usuario por defecto
      final defaultUser = UserProfileDto(
        id: userId,
        nombres: 'Usuario',
        apellidos: userId.toString(),
        email: '',
        foto: null,
        role: null,
      );
      _usersCache[userId] = defaultUser;
      
      return Success(defaultUser);
    } catch (error) {
      // En caso de error, devolver un usuario por defecto
      final defaultUser = UserProfileDto(
        id: userId,
        nombres: 'Usuario',
        apellidos: userId.toString(),
        email: '',
        foto: null,
        role: null,
      );
      _usersCache[userId] = defaultUser;
      
      return Success(defaultUser);
    }
  }

  /// GET /api/v1/users/me - Obtener información del usuario actual
  Future<Resource<UserProfileDto>> getCurrentUser() async {
    try {
      final response = await _apiClient.get('users/me');
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        final user = UserProfileDto.fromJson(json);
        
        // Guardar en cache
        _usersCache[user.id] = user;
        
        return Success(user);
      }
      return Error('Error al cargar el usuario actual');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Obtener múltiples usuarios de una vez
  Future<List<UserProfileDto>> getUsersByIds(List<int> userIds) async {
    final uniqueIds = userIds.toSet().toList();
    final users = <UserProfileDto>[];
    
    for (final id in uniqueIds) {
      final result = await getUserById(id);
      if (result is Success<UserProfileDto>) {
        users.add(result.data!);
      }
    }
    
    return users;
  }

  /// Limpiar cache
  void clearCache() {
    _usersCache.clear();
  }
}

class UserProfileDto {
  final int id;
  final String nombres;
  final String apellidos;
  final String email;
  final String? foto;
  final String? role;
  final String? username;
  final String? ubicacion;
  final String? descripcion;
  final String? telefono;
  final String? fechaNacimiento;
  final Map<String, String>? redesSociales;
  final String? roleName;

  UserProfileDto({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.email,
    this.foto,
    this.role,
    this.username,
    this.ubicacion,
    this.descripcion,
    this.telefono,
    this.fechaNacimiento,
    this.redesSociales,
    this.roleName,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: json['id'] ?? 0,
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      email: json['email'] ?? '',
      foto: json['foto'],
      role: json['role'],
      username: json['username'],
      ubicacion: json['ubicacion'],
      descripcion: json['descripcion'],
      telefono: json['telefono'],
      fechaNacimiento: json['fechaNacimiento'],
      redesSociales: json['redesSociales'] != null
          ? Map<String, String>.from(json['redesSociales'])
          : null,
      roleName: json['roleName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'foto': foto,
      'role': role,
      'username': username,
      'ubicacion': ubicacion,
      'descripcion': descripcion,
      'telefono': telefono,
      'fechaNacimiento': fechaNacimiento,
      'redesSociales': redesSociales,
      'roleName': roleName,
    };
  }

  String get fullName => '$nombres $apellidos';
  
  String get displayName => fullName.trim().isEmpty ? '@user$id' : fullName;
  
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty || fullName.trim().isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  
  String get photoUrl => foto ?? 'https://i.pinimg.com/736x/e5/91/dc/e591dc82326cc4c86578e3eeecced792.jpg';
}
