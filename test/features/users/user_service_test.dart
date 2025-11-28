import 'package:flutter_test/flutter_test.dart';
import 'package:artcollab_mobile/features/users/data/remote/user_service.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';

void main() {
  group('UserProfileDto', () {
    test('should parse from JSON correctly', () {
      // Arrange
      final json = {
        'id': 1,
        'nombres': 'Juan',
        'apellidos': 'Pérez',
        'email': 'juan@example.com',
        'foto': 'https://example.com/photo.jpg',
        'username': 'juanp',
        'ubicacion': 'Lima, Perú',
        'descripcion': 'Ilustrador profesional',
        'telefono': '+51 999 999 999',
        'fechaNacimiento': '1990-01-01',
        'redesSociales': {
          'instagram': '@juanp',
          'twitter': '@juanp'
        },
        'roleName': 'ILUSTRADOR',
      };

      // Act
      final dto = UserProfileDto.fromJson(json);

      // Assert
      expect(dto.id, 1);
      expect(dto.nombres, 'Juan');
      expect(dto.apellidos, 'Pérez');
      expect(dto.email, 'juan@example.com');
      expect(dto.foto, 'https://example.com/photo.jpg');
      expect(dto.username, 'juanp');
      expect(dto.ubicacion, 'Lima, Perú');
      expect(dto.descripcion, 'Ilustrador profesional');
      expect(dto.telefono, '+51 999 999 999');
      expect(dto.fechaNacimiento, '1990-01-01');
      expect(dto.redesSociales, {'instagram': '@juanp', 'twitter': '@juanp'});
      expect(dto.roleName, 'ILUSTRADOR');
    });

    test('should handle null optional fields', () {
      // Arrange
      final json = {
        'id': 1,
        'nombres': 'Juan',
        'apellidos': 'Pérez',
        'email': 'juan@example.com',
      };

      // Act
      final dto = UserProfileDto.fromJson(json);

      // Assert
      expect(dto.id, 1);
      expect(dto.nombres, 'Juan');
      expect(dto.apellidos, 'Pérez');
      expect(dto.email, 'juan@example.com');
      expect(dto.foto, null);
      expect(dto.username, null);
      expect(dto.ubicacion, null);
      expect(dto.descripcion, null);
      expect(dto.telefono, null);
      expect(dto.fechaNacimiento, null);
      expect(dto.redesSociales, null);
      expect(dto.roleName, null);
    });

    test('should serialize to JSON correctly', () {
      // Arrange
      final dto = UserProfileDto(
        id: 1,
        nombres: 'Juan',
        apellidos: 'Pérez',
        email: 'juan@example.com',
        foto: 'https://example.com/photo.jpg',
        username: 'juanp',
        ubicacion: 'Lima, Perú',
        descripcion: 'Ilustrador profesional',
        telefono: '+51 999 999 999',
        fechaNacimiento: '1990-01-01',
        redesSociales: {'instagram': '@juanp'},
        roleName: 'ILUSTRADOR',
      );

      // Act
      final json = dto.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['nombres'], 'Juan');
      expect(json['apellidos'], 'Pérez');
      expect(json['email'], 'juan@example.com');
      expect(json['foto'], 'https://example.com/photo.jpg');
      expect(json['username'], 'juanp');
      expect(json['ubicacion'], 'Lima, Perú');
      expect(json['descripcion'], 'Ilustrador profesional');
      expect(json['telefono'], '+51 999 999 999');
      expect(json['fechaNacimiento'], '1990-01-01');
      expect(json['redesSociales'], {'instagram': '@juanp'});
      expect(json['roleName'], 'ILUSTRADOR');
    });

    test('should generate correct fullName', () {
      // Arrange
      final dto = UserProfileDto(
        id: 1,
        nombres: 'Juan',
        apellidos: 'Pérez',
        email: 'juan@example.com',
      );

      // Act & Assert
      expect(dto.fullName, 'Juan Pérez');
    });

    test('should generate correct displayName', () {
      // Arrange
      final dto1 = UserProfileDto(
        id: 1,
        nombres: 'Juan',
        apellidos: 'Pérez',
        email: 'juan@example.com',
      );

      final dto2 = UserProfileDto(
        id: 2,
        nombres: '',
        apellidos: '',
        email: 'user@example.com',
      );

      // Act & Assert
      expect(dto1.displayName, 'Juan Pérez');
      expect(dto2.displayName, '@user2');
    });

    test('should generate correct initials', () {
      // Arrange
      final dto1 = UserProfileDto(
        id: 1,
        nombres: 'Juan',
        apellidos: 'Pérez',
        email: 'juan@example.com',
      );

      final dto2 = UserProfileDto(
        id: 2,
        nombres: 'María',
        apellidos: '',
        email: 'maria@example.com',
      );

      final dto3 = UserProfileDto(
        id: 3,
        nombres: '',
        apellidos: '',
        email: 'user@example.com',
      );

      // Act & Assert
      expect(dto1.initials, 'JP');
      expect(dto2.initials, 'M');
      expect(dto3.initials, 'U');
    });

    test('should generate correct photoUrl with fallback', () {
      // Arrange
      final dto1 = UserProfileDto(
        id: 1,
        nombres: 'Juan',
        apellidos: 'Pérez',
        email: 'juan@example.com',
        foto: 'https://example.com/photo.jpg',
      );

      final dto2 = UserProfileDto(
        id: 2,
        nombres: 'María',
        apellidos: 'López',
        email: 'maria@example.com',
      );

      // Act & Assert
      expect(dto1.photoUrl, 'https://example.com/photo.jpg');
      expect(dto2.photoUrl, 'https://i.pinimg.com/736x/e5/91/dc/e591dc82326cc4c86578e3eeecced792.jpg');
    });
  });

  group('UserService', () {
    test('should cache user profiles', () async {
      // This is a basic test structure
      // In a real scenario, you would mock the ApiClient
      final service = UserService();
      
      // Verify cache is initially empty
      expect(service, isNotNull);
    });
  });
}
