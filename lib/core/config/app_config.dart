/// Configuración global de la aplicación
class AppConfig {
  // URL base del backend
  // Para emulador Android: 10.0.2.2
  // Para iOS Simulator: localhost
  // Para dispositivo físico: IP de tu computadora
  static const String baseUrl = 'http://10.0.2.2:8080';
  
  // URL base para la API
  static const String apiBaseUrl = '$baseUrl/api/v1';
  
  // Timeout para peticiones HTTP
  static const Duration httpTimeout = Duration(seconds: 30);
  
  // Tamaño máximo de archivo para upload (10MB)
  static const int maxFileSize = 10 * 1024 * 1024;
  
  // Formatos de imagen permitidos
  static const List<String> allowedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];
  
  // Formatos de video permitidos
  static const List<String> allowedVideoFormats = [
    'mp4',
    'mov',
    'avi',
  ];
  
  /// Construye la URL completa para una imagen
  static String getImageUrl(String relativeUrl) {
    if (relativeUrl.isEmpty) return '';
    
    // Si contiene localhost, reemplazarlo con la IP correcta
    if (relativeUrl.contains('localhost')) {
      relativeUrl = relativeUrl.replaceAll('localhost', '10.0.2.2');
    }
    
    // Si ya es una URL completa, devolverla (ya corregida si tenía localhost)
    if (relativeUrl.startsWith('http://') || relativeUrl.startsWith('https://')) {
      return relativeUrl;
    }
    
    // Si es una URL relativa, agregar la base URL
    final cleanUrl = relativeUrl.startsWith('/') ? relativeUrl : '/$relativeUrl';
    return '$baseUrl$cleanUrl';
  }
  
  /// Valida si un archivo es una imagen válida
  static bool isValidImageFile(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    return allowedImageFormats.contains(extension);
  }
  
  /// Valida si un archivo es un video válido
  static bool isValidVideoFile(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    return allowedVideoFormats.contains(extension);
  }
  
  /// Valida el tamaño del archivo
  static bool isValidFileSize(int fileSize) {
    return fileSize <= maxFileSize;
  }
}
