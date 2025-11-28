import 'dart:convert';
import 'dart:io';
import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/features/feed/data/remote/post_dto.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MediaService {
  final ApiClient _apiClient;

  MediaService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Upload a media file (image or video)
  /// Returns the full URL of the uploaded image
  Future<Resource<String>> uploadFile({
    required File file,
    String? altText,
  }) async {
    try {
      final uri = Uri.parse('${_apiClient.baseUrl}/media/upload');
      final request = http.MultipartRequest('POST', uri);

      // Add authorization header
      final token = await _apiClient.tokenStorage.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add file
      final fileExtension = file.path.split('.').last.toLowerCase();
      final mimeType = _getMimeType(fileExtension);
      
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      // Add alt text if provided
      if (altText != null && altText.isNotEmpty) {
        request.fields['altText'] = altText;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.created || response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        // El backend devuelve { "url": "/uploads/..." }
        // Necesitamos concatenar con la URL base
        final relativeUrl = json['url'] as String;
        final fullUrl = '${_apiClient.baseUrl}$relativeUrl';
        return Success(fullUrl);
      }

      final errorJson = jsonDecode(response.body);
      return Error(errorJson['error'] ?? 'Failed to upload file');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }
  
  /// Upload a media file and return MediaDto (legacy method)
  Future<Resource<MediaDto>> uploadFileWithMetadata({
    required File file,
    String? altText,
  }) async {
    try {
      final uri = Uri.parse('${_apiClient.baseUrl}/media/upload');
      final request = http.MultipartRequest('POST', uri);

      // Add authorization header
      final token = await _apiClient.tokenStorage.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add file
      final fileExtension = file.path.split('.').last.toLowerCase();
      final mimeType = _getMimeType(fileExtension);
      
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      // Add alt text if provided
      if (altText != null && altText.isNotEmpty) {
        request.fields['altText'] = altText;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.created || response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        final media = MediaDto.fromJson(json);
        return Success(media);
      }

      final errorJson = jsonDecode(response.body);
      return Error(errorJson['error'] ?? 'Failed to upload file');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Delete a media file
  Future<Resource<void>> deleteFile(int mediaId) async {
    try {
      final response = await _apiClient.delete('media/$mediaId');

      if (response.statusCode == HttpStatus.ok) {
        return Success(null);
      }

      return Error('Failed to delete file');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get media file information
  Future<Resource<MediaDto>> getFileInfo(int mediaId) async {
    try {
      final response = await _apiClient.get('media/$mediaId');

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        final media = MediaDto.fromJson(json);
        return Success(media);
      }

      return Error('Failed to get file info');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Determine MIME type based on file extension
  String _getMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      default:
        return 'application/octet-stream';
    }
  }
}
