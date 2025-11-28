# 🧪 Guía de Pruebas - Backend Integration

## 📊 Estado Actual: 24% Completado (5 de 21 tareas)

### ✅ Funcionalidades Implementadas

#### 1. Autenticación (100% funcional)
- Login con backend real
- Registro de usuarios
- Almacenamiento automático de tokens JWT
- Manejo de errores

#### 2. Infraestructura (100% funcional)
- Cliente HTTP con interceptores
- Manejo de timeouts y errores de red
- Socket.IO para tiempo real
- Token storage seguro

#### 3. Feed Básico (70% funcional)
- Obtener posts con paginación
- Crear posts
- Eliminar posts
- Comentarios y reacciones

---

## 🧪 Cómo Probar

### Opción 1: Tests Automatizados

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests específicos
flutter test test/core/network/api_client_test.dart
flutter test test/features/auth/auth_service_test.dart
flutter test test/features/feed/feed_service_test.dart
```

**Resultado esperado**: 19 tests pasando ✅

---

### Opción 2: Probar en la App Compilada

#### Prerequisitos:
1. **Backend corriendo**: Asegúrate de que tus microservicios estén corriendo
   - API Gateway en `http://localhost:8080`
   - Auth Service registrado en Eureka
   - Feed Service registrado en Eureka

2. **Configuración de URL**: Verifica que `lib/core/constants/app_constants.dart` apunte correctamente:
   ```dart
   static const String authBaseUrl = 'http://10.0.2.2:8080/api/v1/';
   // 10.0.2.2 es localhost para el emulador Android
   // Para iOS usa: http://localhost:8080/api/v1/
   // Para dispositivo físico usa tu IP local: http://192.168.x.x:8080/api/v1/
   ```

#### Pasos para Probar Login:

1. **Compilar y ejecutar la app**:
   ```bash
   flutter run
   ```

2. **Probar Login**:
   - Abre la app
   - Ingresa credenciales válidas de tu backend
   - Presiona "Login"
   
   **✅ Comportamiento esperado**:
   - Si las credenciales son correctas: navegación a la pantalla principal
   - Si son incorrectas: mensaje de error del backend
   - Si no hay conexión: "Unable to connect. Please check your internet connection."

3. **Verificar Token Almacenado**:
   El token JWT se guarda automáticamente en SharedPreferences después del login exitoso.

#### Pasos para Probar Registro:

1. En la pantalla de login, ir a registro
2. Llenar el formulario con datos válidos
3. Presionar "Registrar"

   **✅ Comportamiento esperado**:
   - Usuario creado exitosamente: mensaje de confirmación
   - Usuario ya existe: mensaje de error
   - Datos inválidos: mensaje de validación

---

## 🔍 Verificar Comunicación con Backend

### Ver logs de red:

Agrega esto temporalmente en `api_client.dart` para debug:

```dart
final response = await _client.post(uri, headers: headers, body: jsonEncode(body));
print('📤 Request: ${uri.toString()}');
print('📥 Response: ${response.statusCode} - ${response.body}');
```

### Verificar en el backend:

Revisa los logs de tu API Gateway y Auth Service para ver las peticiones llegando:
- `POST /api/v1/authentication/sign-in`
- `POST /api/v1/authentication/sign-up`

---

## 🐛 Troubleshooting

### Error: "Unable to connect"
- ✅ Verifica que el backend esté corriendo
- ✅ Verifica la URL en `app_constants.dart`
- ✅ Si usas emulador Android, usa `10.0.2.2` en lugar de `localhost`
- ✅ Si usas dispositivo físico, usa tu IP local (ej: `192.168.1.100`)

### Error: "Session expired"
- ✅ El token JWT expiró o es inválido
- ✅ La app automáticamente limpia el token y redirige al login

### Tests fallan
- ✅ Ejecuta `flutter pub get` primero
- ✅ Verifica que todas las dependencias estén instaladas

---

## 📝 Próximos Pasos

Para tener la integración completa, aún faltan implementar:

### Prioridad Alta:
- [ ] Chat Service (mensajería)
- [ ] Notifications Service
- [ ] Portfolio Service
- [ ] Projects Service (proyectos y postulaciones)

### Prioridad Media:
- [ ] User Profiles Service
- [ ] Error handling comprehensivo
- [ ] Caching de datos

### Prioridad Baja:
- [ ] Subscriptions
- [ ] Optimizaciones de rendimiento

---

## 📊 Cobertura de Tests

Actualmente: **19 tests pasando**

- ✅ 4 property tests de HTTP Client
- ✅ 8 tests de Socket.IO
- ✅ 4 property tests de Autenticación
- ✅ 3 property tests de Feed

**Meta**: 51 property tests + tests unitarios (según el spec)

---

## 🚀 Comandos Útiles

```bash
# Ver cobertura de tests
flutter test --coverage

# Ejecutar app en modo debug
flutter run

# Ejecutar app en modo release
flutter run --release

# Limpiar y reconstruir
flutter clean && flutter pub get && flutter run

# Ver logs detallados
flutter run -v
```

---

## 📞 Endpoints Implementados

### Autenticación
- ✅ `POST /api/v1/authentication/sign-in`
- ✅ `POST /api/v1/authentication/sign-up`

### Feed
- ✅ `GET /api/v1/posts?page=0&size=10`
- ✅ `POST /api/v1/posts`
- ✅ `DELETE /api/v1/posts/{postId}`
- ✅ `POST /api/v1/posts/{postId}/comments`
- ✅ `POST /api/v1/posts/{postId}/reactions`
- ✅ `DELETE /api/v1/posts/{postId}/reactions`

### Socket.IO
- ✅ Conexión a `/ws` con autenticación
- ✅ Eventos: `post:created`, `post:deleted`, `post:updated`

---

## ✨ Características Implementadas

### Seguridad
- ✅ Tokens JWT almacenados de forma segura
- ✅ Headers de autenticación automáticos
- ✅ Limpieza automática de tokens expirados (401)

### Manejo de Errores
- ✅ Errores de red con mensajes amigables
- ✅ Timeouts configurables (30 segundos)
- ✅ Parsing de errores del backend
- ✅ Reintentos automáticos en Socket.IO

### Tiempo Real
- ✅ Conexión WebSocket con reconexión automática
- ✅ Listeners para eventos del feed
- ✅ Desconexión limpia

---

**Última actualización**: Tarea 5 de 21 completada
**Progreso**: 24% ✅
