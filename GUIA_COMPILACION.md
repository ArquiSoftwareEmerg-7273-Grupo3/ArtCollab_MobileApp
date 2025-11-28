# Guía de Compilación y Prueba - ArtCollab Mobile App

## 📋 Requisitos Previos

Antes de compilar, asegúrate de tener instalado:

1. **Flutter SDK** (versión 3.0 o superior)
   - Verifica con: `flutter --version`
   
2. **Android Studio** (para compilar en Android)
   - Android SDK
   - Emulador Android o dispositivo físico conectado

3. **Xcode** (para compilar en iOS - solo macOS)
   - Simulador iOS o dispositivo físico

4. **Backend Services** ejecutándose:
   - API Gateway (puerto 8080)
   - Auth Service
   - Feed Service
   - Chat Service
   - Notification Service
   - Portfolio Service
   - Project Service

## 🔧 Configuración Inicial

### 1. Verificar Instalación de Flutter

```bash
flutter doctor
```

Este comando te mostrará si falta algo por instalar.

### 2. Instalar Dependencias

Desde la carpeta `ArtCollab_MobileApp`:

```bash
flutter pub get
```

### 3. Configurar URL del Backend

Edita el archivo `lib/core/constants/app_constants.dart` y asegúrate de que la URL apunte a tu backend:

```dart
class AppConstants {
  // Cambia esta URL según donde esté corriendo tu backend
  static const String authBaseUrl = 'http://localhost:8080/api/v1/';
  
  // Para dispositivo físico Android, usa la IP de tu computadora:
  // static const String authBaseUrl = 'http://192.168.1.X:8080/api/v1/';
  
  // Para emulador Android, usa:
  // static const String authBaseUrl = 'http://10.0.2.2:8080/api/v1/';
}
```

## 🚀 Compilar y Ejecutar

### Opción 1: Modo Debug (Desarrollo)

#### Para Android:

1. **Conectar dispositivo o iniciar emulador**
   ```bash
   # Ver dispositivos disponibles
   flutter devices
   ```

2. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

3. **Hot Reload durante desarrollo**
   - Presiona `r` en la terminal para recargar
   - Presiona `R` para reiniciar completamente
   - Presiona `q` para salir

#### Para iOS (solo macOS):

```bash
# Abrir simulador
open -a Simulator

# Ejecutar la aplicación
flutter run
```

### Opción 2: Compilar APK (Android)

#### APK de Debug:
```bash
flutter build apk --debug
```
El APK estará en: `build/app/outputs/flutter-apk/app-debug.apk`

#### APK de Release (optimizado):
```bash
flutter build apk --release
```
El APK estará en: `build/app/outputs/flutter-apk/app-release.apk`

#### App Bundle (para Google Play Store):
```bash
flutter build appbundle --release
```

### Opción 3: Compilar para iOS

```bash
# Modo debug
flutter build ios --debug

# Modo release
flutter build ios --release
```

## 🧪 Ejecutar Pruebas

### Todas las pruebas:
```bash
flutter test
```

### Pruebas específicas:
```bash
# Pruebas de autenticación
flutter test test/features/auth/

# Pruebas de feed
flutter test test/features/feed/

# Pruebas de red
flutter test test/core/network/
```

### Ver cobertura de pruebas:
```bash
flutter test --coverage
```

## 📱 Probar Funcionalidades Implementadas

### 1. Autenticación

**Funcionalidades disponibles:**
- ✅ Login con usuario y contraseña
- ✅ Registro de nuevos usuarios
- ✅ Almacenamiento seguro de JWT token
- ✅ Manejo de sesión expirada

**Cómo probar:**
1. Abre la aplicación
2. Verás la pantalla de login
3. Ingresa credenciales válidas o regístrate
4. El token se guardará automáticamente
5. Navega por la app (el token se incluye en todas las peticiones)

**Endpoints usados:**
- `POST /api/v1/authentication/sign-in`
- `POST /api/v1/authentication/sign-up`

### 2. Feed de Posts

**Funcionalidades disponibles:**
- ✅ Ver lista de posts con paginación
- ✅ Crear nuevos posts
- ✅ Eliminar posts propios
- ✅ Agregar comentarios a posts
- ✅ Agregar/quitar reacciones (like, love, etc.)
- ✅ Crear/quitar reposts
- ✅ Actualizaciones en tiempo real con Socket.IO

**Cómo probar:**
1. Después de login, navega al feed
2. Verás la lista de posts
3. Scroll para cargar más posts (paginación)
4. Toca el botón de crear post
5. Agrega comentarios y reacciones
6. Las actualizaciones en tiempo real se verán automáticamente

**Endpoints usados:**
- `GET /api/v1/posts?page=0&size=10`
- `POST /api/v1/posts`
- `DELETE /api/v1/posts/{postId}`
- `POST /api/v1/posts/{postId}/comments`
- `POST /api/v1/posts/{postId}/reactions`
- `DELETE /api/v1/posts/{postId}/reactions`
- `POST /api/v1/posts/{postId}/reposts`

### 3. Subida de Archivos

**Funcionalidades disponibles:**
- ✅ Subir imágenes y videos
- ✅ Soporte para múltiples formatos (jpg, png, gif, mp4, etc.)
- ✅ Eliminación de archivos

**Cómo probar:**
1. Al crear un post, selecciona "Agregar imagen/video"
2. Elige un archivo de tu galería
3. El archivo se subirá automáticamente
4. Verás la URL del archivo en el post

**Endpoints usados:**
- `POST /api/v1/media/upload`
- `DELETE /api/v1/media/{id}`

## 🔍 Verificar Conexión con Backend

### Método 1: Logs en la Aplicación

Durante la ejecución, verás logs en la terminal:

```
✅ Connected to backend
🔌 Socket.IO connected
📤 Sending request to: http://localhost:8080/api/v1/posts
✅ Response received: 200
```

### Método 2: Verificar Manualmente

Abre una terminal y prueba los endpoints:

```bash
# Verificar que el API Gateway esté corriendo
curl http://localhost:8080/actuator/health

# Probar login
curl -X POST http://localhost:8080/api/v1/authentication/sign-in \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123"}'

# Probar obtener posts (necesitas el token del login)
curl http://localhost:8080/api/v1/posts?page=0&size=10 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 🐛 Solución de Problemas Comunes

### Error: "Unable to connect"

**Causa:** El backend no está corriendo o la URL es incorrecta

**Solución:**
1. Verifica que todos los servicios del backend estén corriendo
2. Verifica la URL en `app_constants.dart`
3. Si usas emulador Android, usa `10.0.2.2` en lugar de `localhost`
4. Si usas dispositivo físico, usa la IP de tu computadora

### Error: "Session expired"

**Causa:** El token JWT expiró

**Solución:**
1. Cierra sesión y vuelve a iniciar sesión
2. El token se renovará automáticamente

### Error: "Failed to load posts"

**Causa:** El feed-service no está corriendo o hay un error en el backend

**Solución:**
1. Verifica que el feed-service esté corriendo en el puerto correcto
2. Revisa los logs del backend
3. Verifica que el API Gateway esté enrutando correctamente

### Error de compilación: "Gradle build failed"

**Solución:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Error: "CocoaPods not installed" (iOS)

**Solución:**
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

## 📊 Estado de Implementación

### ✅ Completado:
- [x] HTTP Client con autenticación
- [x] Socket.IO para tiempo real
- [x] Almacenamiento de tokens
- [x] Servicio de autenticación
- [x] Servicio de feed (posts, comentarios, reacciones, reposts)
- [x] Servicio de subida de archivos
- [x] Repositorios con transformación DTO ↔ Entity
- [x] BLoC para gestión de estado del feed
- [x] Pruebas unitarias y de propiedades

### 🚧 Pendiente:
- [ ] Servicio de chat
- [ ] Servicio de notificaciones
- [ ] Servicio de portafolio
- [ ] Servicio de proyectos
- [ ] Perfiles de usuario
- [ ] Manejo de errores completo
- [ ] Sistema de caché
- [ ] UI actualizada con datos reales

## 📝 Notas Importantes

1. **Modo Debug vs Release:**
   - Debug: Incluye herramientas de desarrollo, hot reload, más logs
   - Release: Optimizado, sin herramientas de desarrollo, más rápido

2. **Permisos:**
   - La app necesita permisos de internet (ya configurado)
   - Para subir archivos, necesita permisos de almacenamiento

3. **Arquitectura:**
   - Seguimos Clean Architecture
   - Capa de presentación (BLoC)
   - Capa de dominio (Entities)
   - Capa de datos (Services, Repositories, DTOs)

4. **Testing:**
   - Todas las pruebas deben pasar antes de compilar para producción
   - Ejecuta `flutter test` regularmente

## 🎯 Próximos Pasos

1. Implementar servicios restantes (chat, notificaciones, etc.)
2. Actualizar UI para usar datos reales del backend
3. Agregar manejo de errores más robusto
4. Implementar sistema de caché para modo offline
5. Agregar más pruebas de integración

## 📞 Soporte

Si encuentras problemas:
1. Revisa los logs de la aplicación
2. Revisa los logs del backend
3. Verifica la conectividad de red
4. Asegúrate de que todos los servicios estén corriendo

---

**¡Listo para probar!** 🚀

Ejecuta `flutter run` y comienza a explorar la aplicación.
