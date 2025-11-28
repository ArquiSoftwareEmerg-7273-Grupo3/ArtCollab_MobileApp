# Fix: Imágenes con localhost en Base de Datos

## 🐛 Problema Identificado

**Error:**
```
Connection refused (OS Error: Connection refused, errno = 111), 
address = localhost, port = XXXXX
```

**Causa:**
Las imágenes que ya están guardadas en la base de datos tienen URLs con `localhost`:
```
http://localhost:8080/uploads/imagen.jpg
```

Pero el emulador Android no puede acceder a `localhost` - necesita usar `10.0.2.2`.

---

## ✅ Soluciones Aplicadas

### 1. Reemplazo Automático de localhost

**Archivo:** `lib/core/config/app_config.dart`

**Método actualizado:**
```dart
static String getImageUrl(String relativeUrl) {
  if (relativeUrl.isEmpty) return '';
  
  // ✅ NUEVO: Reemplazar localhost con 10.0.2.2
  if (relativeUrl.contains('localhost')) {
    relativeUrl = relativeUrl.replaceAll('localhost', '10.0.2.2');
  }
  
  // Si ya es una URL completa, devolverla (ya corregida)
  if (relativeUrl.startsWith('http://') || relativeUrl.startsWith('https://')) {
    return relativeUrl;
  }
  
  // Si es relativa, agregar base URL
  final cleanUrl = relativeUrl.startsWith('/') ? relativeUrl : '/$relativeUrl';
  return '$baseUrl$cleanUrl';
}
```

**Resultado:**
```
Entrada:  http://localhost:8080/uploads/imagen.jpg
Salida:   http://10.0.2.2:8080/uploads/imagen.jpg ✅
```

### 2. Logs para Debug

**Agregados logs temporales en:**
- `NetworkImageWithFallback` - Para ver URLs de imágenes
- `UserAvatar` - Para ver URLs de avatares

**Ejemplo de logs:**
```
🖼️ NetworkImageWithFallback - Original URL: http://localhost:8080/uploads/img.jpg
🖼️ NetworkImageWithFallback - Full URL: http://10.0.2.2:8080/uploads/img.jpg
```

### 3. Sincronización de URLs

**Actualizado `AppConstants`:**
```dart
class AppConstants {
  static const String authBaseUrl = 'http://10.0.2.2:8080/api/v1/';
  static const String baseUrl = 'http://10.0.2.2:8080';
}
```

**Actualizado `AppConfig`:**
```dart
class AppConfig {
  static const String baseUrl = 'http://10.0.2.2:8080';
  static const String apiBaseUrl = '$baseUrl/api/v1';
}
```

---

## 🔄 Flujo de Corrección de URLs

### Caso 1: URL con localhost (datos antiguos)
```
BD:        http://localhost:8080/uploads/imagen.jpg
           ↓ (getImageUrl reemplaza localhost)
Corregida: http://10.0.2.2:8080/uploads/imagen.jpg
           ↓
Widget:    Image.network(url corregida) ✅
```

### Caso 2: URL relativa
```
BD:        /uploads/imagen.jpg
           ↓ (getImageUrl agrega base)
Completa:  http://10.0.2.2:8080/uploads/imagen.jpg
           ↓
Widget:    Image.network(url completa) ✅
```

### Caso 3: URL ya correcta
```
BD:        http://10.0.2.2:8080/uploads/imagen.jpg
           ↓ (getImageUrl no modifica)
Sin cambio: http://10.0.2.2:8080/uploads/imagen.jpg
           ↓
Widget:    Image.network(url correcta) ✅
```

---

## 🔍 Cómo Verificar que Funciona

### 1. Revisar Logs en Flutter
```bash
flutter logs | grep "🖼️"
```

Deberías ver:
```
🖼️ NetworkImageWithFallback - Original URL: http://localhost:8080/uploads/...
🖼️ NetworkImageWithFallback - Full URL: http://10.0.2.2:8080/uploads/...
```

### 2. Verificar Conexión al Backend
Desde el emulador, la app debería poder conectarse a:
```
http://10.0.2.2:8080/api/v1/...
```

### 3. Probar Manualmente
Abrir en navegador del emulador:
```
http://10.0.2.2:8080/uploads/nombre-imagen.jpg
```

---

## 🚨 Si Aún No Funciona

### Verificar que el Backend Está Corriendo

```bash
# En Windows PowerShell
netstat -ano | findstr :8080

# Debería mostrar algo como:
# TCP    0.0.0.0:8080    0.0.0.0:0    LISTENING    [PID]
```

### Verificar que el Backend Acepta Conexiones Externas

El backend debe estar configurado para escuchar en `0.0.0.0:8080`, no solo en `localhost:8080`.

**Spring Boot (application.properties):**
```properties
server.address=0.0.0.0
server.port=8080
```

### Verificar Firewall

El firewall de Windows puede estar bloqueando conexiones al puerto 8080:

```powershell
# Agregar regla de firewall (ejecutar como administrador)
netsh advfirewall firewall add rule name="ArtCollab Backend" dir=in action=allow protocol=TCP localport=8080
```

---

## 🎯 Solución Alternativa: Usar IP Real

Si `10.0.2.2` no funciona, puedes usar la IP real de tu computadora:

### 1. Obtener tu IP Local

**Windows:**
```cmd
ipconfig
```
Buscar "IPv4 Address" en tu adaptador de red WiFi/Ethernet

**Ejemplo:** `192.168.1.100`

### 2. Actualizar URLs

**En `lib/core/config/app_config.dart`:**
```dart
static const String baseUrl = 'http://192.168.1.100:8080';
```

**En `lib/core/constants/app_constants.dart`:**
```dart
static const String authBaseUrl = 'http://192.168.1.100:8080/api/v1/';
static const String baseUrl = 'http://192.168.1.100:8080';
```

### 3. Actualizar método getImageUrl

```dart
static String getImageUrl(String relativeUrl) {
  if (relativeUrl.isEmpty) return '';
  
  // Reemplazar localhost con IP real
  if (relativeUrl.contains('localhost')) {
    relativeUrl = relativeUrl.replaceAll('localhost', '192.168.1.100');
  }
  
  // Reemplazar 10.0.2.2 con IP real (si migrando)
  if (relativeUrl.contains('10.0.2.2')) {
    relativeUrl = relativeUrl.replaceAll('10.0.2.2', '192.168.1.100');
  }
  
  if (relativeUrl.startsWith('http://') || relativeUrl.startsWith('https://')) {
    return relativeUrl;
  }
  
  final cleanUrl = relativeUrl.startsWith('/') ? relativeUrl : '/$relativeUrl';
  return '$baseUrl$cleanUrl';
}
```

---

## 📱 Configuración por Plataforma

### Emulador Android
```dart
static const String baseUrl = 'http://10.0.2.2:8080';
```

### iOS Simulator
```dart
static const String baseUrl = 'http://localhost:8080';
```

### Dispositivo Físico (Mismo WiFi)
```dart
static const String baseUrl = 'http://192.168.1.X:8080';
```

### Producción
```dart
static const String baseUrl = 'https://api.artcollab.com';
```

---

## 🔧 Pasos Inmediatos

1. **Verificar que el backend está corriendo:**
   ```bash
   curl http://localhost:8080/api/v1/health
   ```

2. **Verificar que acepta conexiones desde 10.0.2.2:**
   - Backend debe escuchar en `0.0.0.0:8080`
   - No solo en `localhost:8080`

3. **Reiniciar la app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

4. **Revisar logs:**
   ```bash
   flutter logs | grep "🖼️"
   ```

5. **Verificar URLs en logs:**
   - Deben mostrar `10.0.2.2` no `localhost`
   - Si aún muestran `localhost`, hay un problema en la construcción de URLs

---

## 💡 Solución Rápida para Testing

Si necesitas probar rápidamente, puedes usar URLs de placeholder:

```dart
// En PortfolioPage o donde se muestren imágenes
final imageUrl = portfolio.urlImagen.isEmpty 
    ? 'https://via.placeholder.com/400'
    : AppConfig.getImageUrl(portfolio.urlImagen);

NetworkImageWithFallback(
  imageUrl: imageUrl,
  ...
)
```

---

## 📊 Checklist de Verificación

- [x] Permisos agregados en AndroidManifest.xml
- [x] URL base actualizada a 10.0.2.2
- [x] Método getImageUrl reemplaza localhost
- [x] Logs agregados para debug
- [ ] Backend corriendo en 0.0.0.0:8080
- [ ] Firewall permite conexiones al puerto 8080
- [ ] App reiniciada con flutter clean
- [ ] Logs verificados (deben mostrar 10.0.2.2)

---

**Próximo Paso:** Reinicia la app con `flutter clean && flutter run` y revisa los logs para ver las URLs que se están construyendo.

---

**Fecha:** 27 de Noviembre, 2025  
**Estado:** 🔧 En Proceso de Verificación
