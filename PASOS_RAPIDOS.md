# 🚀 Pasos Rápidos para Compilar y Probar

## ⚡ Inicio Rápido (5 minutos)

### 1. Preparar el Backend

Asegúrate de que estos servicios estén corriendo:

```bash
# En diferentes terminales, inicia cada servicio:

# Terminal 1 - API Gateway (puerto 8080)
cd api-gateway
./mvnw spring-boot:run

# Terminal 2 - Auth Service
cd auth-service
./mvnw spring-boot:run

# Terminal 3 - Feed Service
cd feed-service
./mvnw spring-boot:run
```

Verifica que estén corriendo:
```bash
curl http://localhost:8080/actuator/health
```

### 2. Configurar la App Móvil

**Opción A: Emulador Android**
```bash
cd ArtCollab_MobileApp
# La URL ya está configurada para emulador: http://10.0.2.2:8080
```

**Opción B: Dispositivo Físico**
```bash
cd ArtCollab_MobileApp
# Edita lib/core/constants/app_constants.dart
# Cambia la URL a: http://TU_IP_LOCAL:8080/api/v1/
# Ejemplo: http://192.168.1.100:8080/api/v1/
```

### 3. Instalar Dependencias

```bash
flutter pub get
```

### 4. Ejecutar la App

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en modo debug
flutter run
```

## 📱 Funcionalidades que Puedes Probar

### ✅ Autenticación
1. Abre la app
2. Verás la pantalla de login
3. Regístrate o inicia sesión
4. El token se guarda automáticamente

**Endpoints:**
- `POST /api/v1/authentication/sign-in`
- `POST /api/v1/authentication/sign-up`

### ✅ Feed de Posts
1. Después del login, ve al feed
2. Crea un nuevo post
3. Agrega comentarios
4. Dale like/reacciones
5. Haz repost
6. Elimina tus posts

**Endpoints:**
- `GET /api/v1/posts` (con paginación)
- `POST /api/v1/posts`
- `DELETE /api/v1/posts/{id}`
- `POST /api/v1/posts/{id}/comments`
- `POST /api/v1/posts/{id}/reactions`
- `POST /api/v1/posts/{id}/reposts`

### ✅ Subida de Archivos
1. Al crear un post, agrega una imagen
2. Selecciona de tu galería
3. Se sube automáticamente

**Endpoints:**
- `POST /api/v1/media/upload`

### ✅ Tiempo Real (Socket.IO)
1. Abre la app en dos dispositivos
2. Crea un post en uno
3. Verás la actualización en el otro automáticamente

## 🔧 Comandos Útiles

```bash
# Ver logs detallados
flutter run -v

# Ejecutar en dispositivo específico
flutter run -d <device-id>

# Compilar APK para instalar
flutter build apk --debug

# Ejecutar todas las pruebas
flutter test

# Limpiar y reconstruir
flutter clean && flutter pub get && flutter run

# Hot reload (durante ejecución)
# Presiona 'r' en la terminal

# Hot restart (durante ejecución)
# Presiona 'R' en la terminal
```

## 🐛 Problemas Comunes

### "Unable to connect"
- ✅ Verifica que el backend esté corriendo
- ✅ Verifica la URL en `app_constants.dart`
- ✅ Para emulador Android usa `10.0.2.2`
- ✅ Para dispositivo físico usa tu IP local

### "Session expired"
- ✅ Cierra sesión y vuelve a iniciar sesión

### "No devices found"
- ✅ Conecta un dispositivo o inicia un emulador
- ✅ Ejecuta `flutter devices` para verificar

## 📊 Lo que Está Implementado

### ✅ Backend Integration
- HTTP Client con autenticación JWT
- Socket.IO para actualizaciones en tiempo real
- Almacenamiento seguro de tokens
- Manejo de errores de red

### ✅ Features
- **Autenticación:** Login, registro, gestión de sesión
- **Feed:** Posts, comentarios, reacciones, reposts
- **Media:** Subida de imágenes y videos
- **Tiempo Real:** Actualizaciones automáticas vía Socket.IO

### ✅ Arquitectura
- Clean Architecture (Presentation, Domain, Data)
- BLoC para gestión de estado
- Repository pattern
- DTOs para transformación de datos

### ✅ Testing
- 31 pruebas unitarias y de propiedades
- Todas las pruebas pasan ✅
- Cobertura de funcionalidades críticas

## 🎯 Siguiente Paso

```bash
# ¡Ejecuta la app ahora!
cd ArtCollab_MobileApp
flutter run
```

## 📸 Capturas de Pantalla

Durante la ejecución verás:
1. **Splash Screen** → Pantalla inicial
2. **Login Screen** → Formulario de login/registro
3. **Feed Screen** → Lista de posts con scroll infinito
4. **Create Post** → Formulario para crear posts
5. **Post Details** → Ver comentarios y reacciones

## 💡 Tips

1. **Hot Reload:** Presiona `r` para ver cambios sin reiniciar
2. **Logs:** Observa la terminal para ver las peticiones HTTP
3. **DevTools:** Usa Flutter DevTools para debugging avanzado
4. **Postman:** Prueba los endpoints manualmente primero

## 📞 ¿Necesitas Ayuda?

1. Revisa `GUIA_COMPILACION.md` para más detalles
2. Ejecuta `flutter doctor` para verificar tu setup
3. Revisa los logs del backend y la app

---

**¡Todo listo! Ejecuta `flutter run` y empieza a probar** 🎉
