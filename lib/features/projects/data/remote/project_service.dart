import 'dart:convert';
import 'dart:io';
import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';

class ProjectService {
  final ApiClient _apiClient;

  ProjectService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// POST /api/v1/proyectos - Crear un nuevo proyecto (requiere Authorization header y rol ESCRITOR)
  Future<Resource<String>> createProject({
    required String titulo,
    required String descripcion,
    required double presupuesto,
    required String modalidadProyecto,
    required String contratoProyecto,
    required String especialidadProyecto,
    required String requisitos,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required int maxPostulaciones,
  }) async {
    try {
      String _formatDate(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}"
         "-${date.month.toString().padLeft(2, '0')}"
         "-${date.day.toString().padLeft(2, '0')}"
         "T${date.hour.toString().padLeft(2, '0')}"
         ":${date.minute.toString().padLeft(2, '0')}"
         ":${date.second.toString().padLeft(2, '0')}";
}
      final response = await _apiClient.post('proyectos', {
        'titulo': titulo,
        'descripcion': descripcion,
        'presupuesto': presupuesto,
        'modalidadProyecto': modalidadProyecto,
        'contratoProyecto': contratoProyecto,
        'especialidadProyecto': especialidadProyecto,
        'requisitos': requisitos,
        'fechaInicio': _formatDate(fechaInicio),
'fechaFin': _formatDate(fechaFin),

        'maxPostulaciones': maxPostulaciones,
      });
      if (response.statusCode == HttpStatus.ok) {
        return Success(response.body);
      }
      return Error('Error al crear el proyecto');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/proyectos - Obtener todos los proyectos
  Future<Resource<List<ProjectDto>>> getAllProjects() async {
    try {
      final response = await _apiClient.get('proyectos');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final projects = json.map((e) => ProjectDto.fromJson(e)).toList();
        return Success(projects);
      }
      return Error('Error al cargar los proyectos');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/proyectos/{id} - Obtener un proyecto por ID
  Future<Resource<ProjectDto>> getProjectById(int id) async {
    try {
      final response = await _apiClient.get('proyectos/$id');
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Success(ProjectDto.fromJson(json));
      }
      return Error('Error al cargar el proyecto');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/proyectos/escritorId/{escritorId} - Obtener proyectos por escritor
  Future<Resource<List<ProjectDto>>> getProjectsByEscritorId(int escritorId) async {
    try {
      final response = await _apiClient.get('proyectos/escritorId/$escritorId');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final projects = json.map((e) => ProjectDto.fromJson(e)).toList();
        return Success(projects);
      }
      return Error('Error al cargar los proyectos del escritor');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/proyectos/mis-proyectos - Obtener mis proyectos (requiere Authorization header)
  Future<Resource<List<ProjectDto>>> getMyProjects() async {
    try {
      final response = await _apiClient.get('proyectos/mis-proyectos');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final projects = json.map((e) => ProjectDto.fromJson(e)).toList();
        return Success(projects);
      }
      return Error('Error al cargar mis proyectos');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// PATCH /api/v1/proyectos/{id}/cerrar - Cerrar un proyecto
  Future<Resource<String>> closeProject(int id) async {
    try {
      final response = await _apiClient.patch('proyectos/$id/cerrar', {});
      if (response.statusCode == HttpStatus.ok) {
        return Success(response.body);
      }
      return Error('Error al cerrar el proyecto');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// PATCH /api/v1/proyectos/{id}/finalizar - Finalizar un proyecto
  Future<Resource<String>> finalizeProject(int id) async {
    try {
      final response = await _apiClient.patch('proyectos/$id/finalizar', {});
      if (response.statusCode == HttpStatus.ok) {
        return Success(response.body);
      }
      return Error('Error al finalizar el proyecto');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// POST /api/v1/postulaciones/postular/proyecto/{proyectoId} - Crear una postulación
  Future<Resource<String>> createApplication({
    required int proyectoId,
    required String mensaje,
  }) async {
    try {
      final response = await _apiClient.post(
        'postulaciones/postular/proyecto/$proyectoId',
        {'mensaje': mensaje},
      );
      if (response.statusCode == HttpStatus.ok) {
        return Success(response.body);
      }
      return Error('Error al crear la postulación');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/postulaciones - Obtener todas las postulaciones
  Future<Resource<List<ApplicationDto>>> getAllApplications() async {
    try {
      final response = await _apiClient.get('postulaciones');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final applications = json.map((e) => ApplicationDto.fromJson(e)).toList();
        return Success(applications);
      }
      return Error('Error al cargar las postulaciones');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/postulaciones/ilustradorId/{ilustradorId} - Obtener postulaciones por ilustrador
  Future<Resource<List<ApplicationDto>>> getApplicationsByIlustradorId(int ilustradorId) async {
    try {
      final response = await _apiClient.get('postulaciones/ilustradorId/$ilustradorId');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final applications = json.map((e) => ApplicationDto.fromJson(e)).toList();
        return Success(applications);
      }
      return Error('Error al cargar las postulaciones del ilustrador');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/postulaciones/proyectoId/{proyectoId} - Obtener postulaciones por proyecto
  Future<Resource<List<ApplicationDto>>> getApplicationsByProyectoId(int proyectoId) async {
    try {
      final response = await _apiClient.get('postulaciones/proyectoId/$proyectoId');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final applications = json.map((e) => ApplicationDto.fromJson(e)).toList();
        return Success(applications);
      }
      return Error('Error al cargar las postulaciones del proyecto');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/postulaciones/mis-postulaciones - Obtener mis postulaciones
  Future<Resource<List<ApplicationDto>>> getMyApplications() async {
    try {
      final response = await _apiClient.get('postulaciones/mis-postulaciones');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final applications = json.map((e) => ApplicationDto.fromJson(e)).toList();
        return Success(applications);
      }
      return Error('Error al cargar mis postulaciones');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// PATCH /api/v1/postulaciones/{id}/aprobar - Aprobar una postulación
  Future<Resource<String>> approveApplication(int id, String respuesta) async {
    try {
      final response = await _apiClient.patch(
        'postulaciones/$id/aprobar',
        {'respuesta': respuesta},
      );
      if (response.statusCode == HttpStatus.ok) {
        return Success(response.body);
      }
      return Error('Error al aprobar la postulación');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// PATCH /api/v1/postulaciones/{id}/rechazar - Rechazar una postulación
  Future<Resource<String>> rejectApplication(int id, String razon) async {
    try {
      final response = await _apiClient.patch(
        'postulaciones/$id/rechazar',
        {'razon': razon},
      );
      if (response.statusCode == HttpStatus.ok) {
        return Success(response.body);
      }
      return Error('Error al rechazar la postulación');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// PATCH /api/v1/postulaciones/{id}/cancelar - Cancelar una postulación
  Future<Resource<String>> cancelApplication(int id) async {
    try {
      final response = await _apiClient.patch('postulaciones/$id/cancelar', {});
      if (response.statusCode == HttpStatus.ok) {
        return Success(response.body);
      }
      return Error('Error al cancelar la postulación');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }
}

class ProjectDto {
  final int id;
  final int escritorId;
  final String titulo;
  final String descripcion;
  final DateTime fechaFin;
  final DateTime fechaInicio;
  final double presupuesto;
  final String estado;
  final String modalidadProyecto;
  final String contratoProyecto;
  final String especialidadProyecto;
  final String requisitos;
  final int maxPostulaciones;
  final String clienteNombre;
  final int postulacionesActuales;
  final DateTime fechaCreacion;

  ProjectDto({
    required this.id,
    required this.escritorId,
    required this.titulo,
    required this.descripcion,
    required this.fechaFin,
    required this.fechaInicio,
    required this.presupuesto,
    required this.estado,
    required this.modalidadProyecto,
    required this.contratoProyecto,
    required this.especialidadProyecto,
    required this.requisitos,
    required this.maxPostulaciones,
    this.clienteNombre = 'Cliente',
    this.postulacionesActuales = 0,
    DateTime? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      id: json['id'] ?? 0,
      escritorId: json['escritorId'] ?? 0,
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fechaFin: DateTime.parse(json['fechaFin'] ?? DateTime.now().toIso8601String()),
      fechaInicio: DateTime.parse(json['fechaInicio'] ?? DateTime.now().toIso8601String()),
      presupuesto: (json['presupuesto'] ?? 0).toDouble(),
      estado: json['estado'] ?? '',
      modalidadProyecto: json['modalidadProyecto'] ?? '',
      contratoProyecto: json['contratoProyecto'] ?? '',
      especialidadProyecto: json['especialidadProyecto'] ?? '',
      requisitos: json['requisitos'] ?? '',
      maxPostulaciones: json['maxPostulaciones'] ?? 0,
      clienteNombre: json['clienteNombre'] ?? 'Cliente',
      postulacionesActuales: json['postulacionesActuales'] ?? 0,
      fechaCreacion: json['fechaCreacion'] != null 
          ? DateTime.parse(json['fechaCreacion'])
          : DateTime.now(),
    );
  }
String _formatDate(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}"
         "-${date.month.toString().padLeft(2, '0')}"
         "-${date.day.toString().padLeft(2, '0')}"
         "T${date.hour.toString().padLeft(2, '0')}"
         ":${date.minute.toString().padLeft(2, '0')}"
         ":${date.second.toString().padLeft(2, '0')}";
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'escritorId': escritorId,
      'titulo': titulo,
      'descripcion': descripcion,
      'fechaInicio': _formatDate(fechaInicio),
'fechaFin': _formatDate(fechaFin),

      'presupuesto': presupuesto,
      'estado': estado,
      'modalidadProyecto': modalidadProyecto,
      'contratoProyecto': contratoProyecto,
      'especialidadProyecto': especialidadProyecto,
      'requisitos': requisitos,
      'maxPostulaciones': maxPostulaciones,
      'clienteNombre': clienteNombre,
      'postulacionesActuales': postulacionesActuales,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }
}

class ApplicationDto {
  final int id;
  final int proyectoId;
  final int ilustradorId;
  final String estado;
  final DateTime fechaPostulacion;
  final String mensaje;
  final String respuesta;
  final DateTime fechaCreacion;

  ApplicationDto({
    required this.id,
    required this.proyectoId,
    required this.ilustradorId,
    required this.estado,
    required this.fechaPostulacion,
    this.mensaje = '',
    this.respuesta = '',
    DateTime? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  factory ApplicationDto.fromJson(Map<String, dynamic> json) {
    return ApplicationDto(
      id: json['id'] ?? 0,
      proyectoId: json['proyectoId'] ?? 0,
      ilustradorId: json['ilustradorId'] ?? 0,
      estado: json['estado'] ?? '',
      fechaPostulacion: DateTime.parse(json['fechaPostulacion'] ?? DateTime.now().toIso8601String()),
      mensaje: json['mensaje'] ?? '',
      respuesta: json['respuesta'] ?? '',
      fechaCreacion: json['fechaCreacion'] != null 
          ? DateTime.parse(json['fechaCreacion'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proyectoId': proyectoId,
      'ilustradorId': ilustradorId,
      'estado': estado,
      'fechaPostulacion': fechaPostulacion.toIso8601String(),
      'mensaje': mensaje,
      'respuesta': respuesta,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }
}
