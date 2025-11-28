# Sistema de Manejo de Imágenes - ArtCollab Mobile

## 📸 Resumen

Se ha implementado un sistema completo para manejar imágenes desde el backend, incluyendo upload, visualización y manejo de URLs.

---

## 🔧 Componentes Implementados

### 1. AppConfig
**Archivo:** `lib/core/config/app_config.dart`

**Propósito:**
- Centralizar la configuración de URLs del backend
- Proporcionar métodos helper para construir URLs completas
- Validar archivos y tamaños

**Características:**
```dart
// URL base del backend
static const String baseUrl = 'http://localhost:8080';

// Construir URL completa para imágenes
static String getImageUrl(String relativeUrl) {
  // Maneja URLs relativas y absolutas automáticamente
}

// Validaciones
static bool isValidImageFile(String filename);
static bool isValidFileSize(int fileSize);
```

---

### 2. MediaService (Actualizado)
**Archivo:** `lib/features/feed/data/remote/media_service.dart`

**Método Principal:**
```dart
Future<Resource<String>> uploadFile({
  required File file,
  String? altText,
}) async {
  // 1. Crea multipart request
  // 2. Agrega el archivo
  // 3. Sube al endpoint /api/v1/media/upload
  // 4. Recibe { "url": "/uploads/..." }
  // 5. Construye URL completa: http://localhost:8080/uploads/...
  // 6. Retorna la URL completa
}
```

**Flujo de Upload:**
```
1. Usuario selecciona imagen
   ↓
2. MediaService.uploadFile(file)
   ↓
3. POST http://localhost:8080/api/v1/media/upload
   ↓
4. Backend responde: { "url": "/uploads/imagen123.jpg" }
   ↓
5. MediaService construye: http://localhost:8080/uploads/imagen123.jpg
   ↓
6. Retorna URL completa
```

---

### 3. NetworkImageWithFallback
**Archivo:** `lib/shared/widgets/network_image_with_fallback.dart`

**Propósito:**
- Widget reutilizable para mostrar imágenes de red
- Maneja automáticamente URLs relativas y absolutas
- Proporciona placeholder durante carga
- Muestra widget de error si falla la carga

**Uso:**
```dart
NetworkImageWithFallback(
  imageUrl: portfolio.urlImagen, // Puede ser relativa o absoluta
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(12),
)
```

**Características:**
- ✅ Convierte URLs relativas a absolutas automáticamente
- ✅ Muestra loading indicator durante carga
- ✅ Muestra icono de error si falla
- ✅ Soporte para border radius
- ✅ Placeholder personalizable

---

### 4. NetworkAvatarImage
**Archivo:** `lib/shared/widgets/network_image_with_fallback.dart`

**Propósito:**
- Widget especializado para avatares circulares
- Fallback a iniciales si no hay imagen

**Uso:**
```dart
NetworkAvatarImage(
  imageUrl: user.photoUrl,
  radius: 24,
  fallbackInitials: 'JD',
)
```

---

### 5. UserAvatar (Actualizado)
**Archivo:** `lib/shared/widgets/user_avatar.dart`

**Mejoras:**
- ✅ Usa AppConfig.getImageUrl() para construir URLs
- ✅ Maneja URLs relativas del backend
- ✅ Fallback automático a iniciales

**Uso:**
```dart
UserAvatar(
  photoUrl: '/uploads/user123.jpg', // URL relativa
  initials: 'JD',
  radius: 24,
)
```

---

## 📋 Flujo Completo de Creación de Portafolio

### Paso 1: Usuario Selecciona Imágenes
```dart
final List<XFile> images = await _imagePicker.pickMultiImage();
setState(() {
  _selectedImages.addAll(images);
});
```

### Paso 2: Upload al Crear Portafolio
```dart
// En CreatePortfolioPage._createPortfolio()

// 1. Subir primera imagen
final mediaService = MediaService();
final file = File(_selectedImages[0].path);
final uploadResult = await mediaService.uploadFile(file: file);

if (uploadResult is Success<String>) {
  uploadedImageUrl = uploadResult.data; // URL completa
}

// 2. Crear portafolio con URL
await _portfolioService.createPortfolio(
  titulo: _tituloController.text,
  descripcion: _descripcionController.text,
  urlImagen: uploadedImageUrl, // http://localhost:8080/uploads/...
);
```

### Paso 3: Backend Guarda URL Relativa
```
Backend recibe: http://localhost:8080/uploads/imagen123.jpg
Backend guarda en DB: /uploads/imagen123.jpg (relativa)
```

### Paso 4: Visualización
```dart
// En PortfolioPage
NetworkImageWithFallback(
  imageUrl: portfolio.urlImagen, // /uploads/imagen123.jpg
  // Widget automáticamente construye:
  // http://localhost:8080/uploads/imagen123.jpg
)
```

---

## 🔄 Manejo de URLs

### URLs Relativas (del Backend)
```
Entrada: "/uploads/imagen123.jpg"
Salida:  "http://localhost:8080/uploads/imagen123.jpg"
```

### URLs Absolutas (ya completas)
```
Entrada: "http://localhost:8080/uploads/imagen123.jpg"
Salida:  "http://localhost:8080/uploads/imagen123.jpg"
```

### URLs Externas
```
Entrada: "https://example.com/image.jpg"
Salida:  "https://example.com/image.jpg"
```

---

## 📝 Endpoints del Backend

### Upload de Imagen
```
POST /api/v1/media/upload
Content-Type: multipart/form-data

Body:
- file: [archivo]
- altText: [opcional]

Response:
{
  "url": "/uploads/imagen123.jpg"
}
```

### Acceso a Imagen
```
GET /uploads/imagen123.jpg

Response: [imagen binaria]
```

---

## ✅ Validaciones Implementadas

### Tamaño de Archivo
```dart
// Máximo 10MB
if (file.size > AppConfig.maxFileSize) {
  // Error
}
```

### Formato de Archivo
```dart
// Solo imágenes permitidas
if (!AppConfig.isValidImageFile(filename)) {
  // Error
}
```

### Formatos Permitidos
- ✅ JPG/JPEG
- ✅ PNG
- ✅ GIF
- ✅ WEBP

---

## 🎨 Widgets Disponibles

### Para Imágenes Generales
```dart
NetworkImageWithFallback(
  imageUrl: imageUrl,
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(12),
  placeholder: CircularProgressIndicator(),
  errorWidget: Icon(Icons.error),
)
```

### Para Avatares
```dart
NetworkAvatarImage(
  imageUrl: userPhotoUrl,
  radius: 24,
  fallbackInitials: 'JD',
)
```

### Para Avatares con Más Control
```dart
UserAvatar(
  photoUrl: userPhotoUrl,
  initials: 'JD',
  radius: 24,
  backgroundColor: Colors.teal,
  textColor: Colors.white,
)
```

---

## 🔧 Configuración

### Cambiar URL del Backend
**Archivo:** `lib/core/config/app_config.dart`

```dart
class AppConfig {
  // Para desarrollo local
  static const String baseUrl = 'http://localhost:8080';
  
  // Para producción
  // static const String baseUrl = 'https://api.artcollab.com';
  
  // Para emulador Android
  // static const String baseUrl = 'http://10.0.2.2:8080';
}
```

---

## 📱 Uso en Diferentes Páginas

### FeedPage
```dart
NetworkImageWithFallback(
  imageUrl: post.mediaUrl,
  width: double.infinity,
  height: 300,
  fit: BoxFit.cover,
)
```

### PortfolioPage
```dart
NetworkImageWithFallback(
  imageUrl: portfolio.urlImagen,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(12),
)
```

### ProfilePage
```dart
UserAvatar(
  photoUrl: user.photoUrl,
  initials: user.initials,
  radius: 40,
)
```

### ChatPage
```dart
NetworkAvatarImage(
  imageUrl: message.senderPhotoUrl,
  radius: 20,
  fallbackInitials: message.senderInitials,
)
```

---

## 🐛 Troubleshooting

### Las imágenes no se muestran

**Problema:** URLs relativas no se convierten correctamente

**Solución:**
1. Verificar que AppConfig.baseUrl sea correcto
2. Verificar que el backend esté corriendo
3. Verificar que las URLs en la DB sean correctas

### Error de CORS

**Problema:** El navegador bloquea las peticiones

**Solución:**
- En desarrollo, el backend debe permitir CORS desde localhost
- Verificar configuración de CORS en el backend

### Imágenes muy grandes

**Problema:** Las imágenes tardan mucho en cargar

**Solución:**
1. Implementar compresión antes de subir
2. Usar thumbnails para listas
3. Implementar lazy loading

---

## 🚀 Próximas Mejoras

### Corto Plazo
- ⏳ Implementar caché de imágenes
- ⏳ Comprimir imágenes antes de subir
- ⏳ Mostrar progreso de upload
- ⏳ Soporte para múltiples imágenes en portafolio

### Mediano Plazo
- ⏳ Thumbnails automáticos
- ⏳ Lazy loading en listas
- ⏳ Optimización de tamaño según dispositivo
- ⏳ Soporte offline con caché

### Largo Plazo
- ⏳ CDN para imágenes
- ⏳ Procesamiento de imágenes en el servidor
- ⏳ Formatos modernos (AVIF, WebP)
- ⏳ Responsive images

---

## 📊 Estadísticas

### Archivos Creados: 3
1. `lib/core/config/app_config.dart`
2. `lib/shared/widgets/network_image_with_fallback.dart`
3. `SISTEMA_IMAGENES.md`

### Archivos Actualizados: 3
1. `lib/features/feed/data/remote/media_service.dart`
2. `lib/shared/widgets/user_avatar.dart`
3. `lib/features/portfolio/presentation/pages/create_portfolio_page.dart`

### Funcionalidades: 100%
- ✅ Upload de imágenes
- ✅ Construcción de URLs
- ✅ Visualización con fallback
- ✅ Validaciones
- ✅ Manejo de errores

---

**Fecha de Implementación:** 27 de Noviembre, 2025  
**Estado:** ✅ Completado  
**Funcionalidad:** ✅ Operativa
