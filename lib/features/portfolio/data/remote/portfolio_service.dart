import 'dart:convert';
import 'dart:io';
import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';

class PortfolioService {
  final ApiClient _apiClient;

  PortfolioService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// POST /api/v1/portafolios - Crear un nuevo portafolio (requiere Authorization header)
  Future<Resource<String>> createPortfolio({
    required String titulo,
    required String descripcion,
    String? urlImagen,
    String? categoria,
    String? tecnicas,
    String? software,
    List<String>? imagePaths,
  }) async {
    try {
      // Por ahora, usamos la primera imagen o una URL por defecto
      final imageUrl = urlImagen ?? 
          (imagePaths != null && imagePaths.isNotEmpty 
              ? 'https://via.placeholder.com/400' 
              : 'https://via.placeholder.com/400');
      
      final response = await _apiClient.post('portafolios', {
        'titulo': titulo,
        'descripcion': descripcion,
        'urlImagen': imageUrl,
      });
      if (response.statusCode == HttpStatus.ok) {
        return Success(response.body);
      }
      return Error('Error al crear el portafolio');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// PUT /api/v1/portafolios/{portafolioId} - Actualizar un portafolio
  Future<Resource<PortfolioDto>> updatePortfolio({
    required int portafolioId,
    required String titulo,
    required String descripcion,
    required String urlImagen,
  }) async {
    try {
      final response = await _apiClient.put('portafolios/$portafolioId', {
        'titulo': titulo,
        'descripcion': descripcion,
        'urlImagen': urlImagen,
      });
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Success(PortfolioDto.fromJson(json));
      }
      return Error('Error al actualizar el portafolio');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/portafolios/ilustrador/{ilustradorId} - Obtener portafolios por ilustrador
  Future<Resource<List<PortfolioDto>>> getPortfoliosByIlustrador(int ilustradorId) async {
    try {
      final response = await _apiClient.get('portafolios/ilustrador/$ilustradorId');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final portfolios = json.map((e) => PortfolioDto.fromJson(e)).toList();
        return Success(portfolios);
      }
      return Error('Error al cargar los portafolios');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/portafolios/mi-portafolio - Obtener mi portafolio (requiere Authorization header)
  Future<Resource<List<PortfolioDto>>> getMyPortfolio() async {
    try {
      final response = await _apiClient.get('portafolios/mi-portafolio');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final portfolios = json.map((e) => PortfolioDto.fromJson(e)).toList();
        return Success(portfolios);
      }
      return Error('Error al cargar mi portafolio');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// POST /api/v1/portafolios/{portafolioId}/ilustraciones - Agregar ilustración a portafolio
  Future<Resource<String>> addIllustrationToPortfolio({
    required int portafolioId,
    required int ilustradorId,
    required String titulo,
    required String descripcion,
    required String urlImagen,
  }) async {
    try {
      final response = await _apiClient.post(
        'portafolios/$portafolioId/ilustraciones?ilustradorId=$ilustradorId',
        {
          'titulo': titulo,
          'descripcion': descripcion,
          'urlImagen': urlImagen,
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        return Success(response.body);
      }
      return Error('Error al agregar la ilustración');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// POST /api/v1/ilustraciones/publicar/{ilustradorId} - Publicar una ilustración
  Future<Resource<String>> publishIllustration({
    required int ilustradorId,
    required String titulo,
    required String descripcion,
    required String urlImagen,
  }) async {
    try {
      final response = await _apiClient.post(
        'ilustraciones/publicar/$ilustradorId',
        {
          'titulo': titulo,
          'descripcion': descripcion,
          'urlImagen': urlImagen,
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        return Success(response.body);
      }
      return Error('Error al publicar la ilustración');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/ilustraciones/ilustrador/{ilustradorId}/publicadas - Obtener ilustraciones publicadas
  Future<Resource<List<IllustrationDto>>> getPublishedIllustrations(int ilustradorId) async {
    try {
      final response = await _apiClient.get('ilustraciones/ilustrador/$ilustradorId/publicadas');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final illustrations = json.map((e) => IllustrationDto.fromJson(e)).toList();
        return Success(illustrations);
      }
      return Error('Error al cargar las ilustraciones publicadas');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/ilustraciones/{ilustracionId}/resumen - Obtener resumen de ilustración
  Future<Resource<IllustrationDto>> getIllustrationSummary(int ilustracionId) async {
    try {
      final response = await _apiClient.get('ilustraciones/$ilustracionId/resumen');
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Success(IllustrationDto.fromJson(json));
      }
      return Error('Error al cargar el resumen de la ilustración');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// DELETE /api/v1/ilustraciones/{ilustracionId} - Eliminar una ilustración
  Future<Resource<void>> deleteIllustration(int ilustracionId) async {
    try {
      final response = await _apiClient.delete('ilustraciones/$ilustracionId');
      if (response.statusCode == HttpStatus.noContent || response.statusCode == HttpStatus.ok) {
        return Success(null);
      }
      return Error('Error al eliminar la ilustración');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// PUT /api/v1/ilustraciones/{ilustracionId} - Actualizar una ilustración
  Future<Resource<IllustrationDto>> updateIllustration({
    required int ilustracionId,
    required String titulo,
    required String descripcion,
    required String urlImagen,
  }) async {
    try {
      final response = await _apiClient.put('ilustraciones/$ilustracionId', {
        'titulo': titulo,
        'descripcion': descripcion,
        'urlImagen': urlImagen,
      });
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Success(IllustrationDto.fromJson(json));
      }
      return Error('Error al actualizar la ilustración');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }
}

class PortfolioDto {
  final int id;
  final String titulo;
  final String descripcion;
  final String urlImagen;
  final List<CategoryDto> categorias;

  PortfolioDto({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.urlImagen,
    required this.categorias,
  });

  factory PortfolioDto.fromJson(Map<String, dynamic> json) {
    return PortfolioDto(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      urlImagen: json['urlImagen'] ?? '',
      categorias: (json['categorias'] as List<dynamic>?)
              ?.map((e) => CategoryDto.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'urlImagen': urlImagen,
      'categorias': categorias.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryDto {
  final int? id;
  final String? nombre;
  final List<IllustrationDto>? ilustraciones;

  CategoryDto({
    this.id,
    this.nombre,
    this.ilustraciones,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: json['id'],
      nombre: json['nombre'],
      ilustraciones: (json['ilustraciones'] as List<dynamic>?)
          ?.map((e) => IllustrationDto.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'ilustraciones': ilustraciones?.map((e) => e.toJson()).toList(),
    };
  }
}

class IllustrationDto {
  final int id;
  final String titulo;
  final String descripcion;
  final String urlImagen;

  IllustrationDto({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.urlImagen,
  });

  factory IllustrationDto.fromJson(Map<String, dynamic> json) {
    return IllustrationDto(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      urlImagen: json['urlImagen'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'urlImagen': urlImagen,
    };
  }
}
