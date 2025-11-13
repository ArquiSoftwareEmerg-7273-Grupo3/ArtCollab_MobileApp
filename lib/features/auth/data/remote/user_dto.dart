import 'package:artcollab_mobile/features/auth/domain/entities/reg_message.dart';
import 'package:artcollab_mobile/features/users/domain/entities/user.dart';

class UserDto {
  final int id;
  final String username;
  final String accessToken;
  final String role;

  const UserDto({
    required this.id,
    required this.username,
    required this.accessToken,
    required this.role
  });

  factory UserDto.fromJson(Map<String, dynamic> json){
    return UserDto(
      id: json['id'] ?? 0, 
      username: json['username'] ?? '', 
      accessToken: json['token'] ?? '',
      role: json['role']);
  }

  User toUser(){
    return User(id: id, username: username, roleName: role);
  }
}

class MessageDto {
  final String message;

  const MessageDto({
    required this.message,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json){
    return MessageDto(
      message: json['message'] ?? '', 
      );
  }

  RegMessage toMessage(){
    return RegMessage(message: message);
  }
}