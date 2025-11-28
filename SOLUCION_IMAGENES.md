# Solución de Problemas con Imágenes - ArtCollab Mobile

## 🔧 Problemas Solucionados

### 1. Error al Seleccionar Imágenes en Android

**Error:**
```
PlatformException(channel-error, Unable to establish connection on channel: "dev.flutter.pigeon.image_picker_android.ImagePickerApi.pickImages", null, null)
```

**Causa:**
- Faltan permisos en AndroidManifest.xml
- Faltan queries para image_picker

**Solución Aplicada:**

#### Archivo: `android/app/src/main/AndroidManifest.xml`

**Permisos agregados:**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

**Queries agregadas:**
```xml
<queries>
    <!-- Queries para image_picker -->
    <intent>
        <action android:name="android.media.action.IMAGE_CAPTURE"/>
    </intent>
    <intent>
        <action android:name="android.intent.action.GET_CONTENT"/>
    </intent>
</queries>
```

---

### 2. Imágenes No Se Muestran (Broken Image Icon)

**Problema:**
- Las imágenes se suben correctamente al backend
- Pero no se visualizan en la app (aparece icono de broken image)

**Causa:**
- URL base incorrecta para emulador Android
- `localhost` no funciona en emulador Android
- Debe usar `10.0.2.2` para acceder al localhost de la máquina host

**Solución Aplicada:**

#### Archivo: `lib/core/config/app_config.dart`

**Antes:**
```dart
static const String baseUrl = 'http://localhost:8080';
```

**Después:**
```dart
static const String baseUrl = 'http://10.0.2.2:8080';
```

---

## 📱 URLs Según Plataforma

### Emulador Android
```dart
static const String baseUrl = 'http://10.0.2.2:8080';
```
- `10.0.2.2` es la IP especial que el emulador Android usa para acceder al localhost del host

### iOS Simulator
```dart
static const String baseUrl = 'http://localhost:8080';
```
- iOS Simulator puede usar `localhost` directamente

### Dispositivo Físico (Mismo WiFi)
```dart
static const String baseUrl = 'http://192.168.1.X:8080';
```
- Reemplazar `192.168.1.X` con la IP local de tu computadora
- Obtener IP en Windows: `ipconfig`
- Obtener IP en Mac/Linux: `ifconfig`

### Producción
```dart
static const String baseUrl = 'https://api.artcollab.com';
```

---

## 🔍 Cómo Verificar que las Imágenes Funcionan

### 1. Verificar que el Backend Está Corriendo
```bash
# Debe estar corriendo en puerto 8080
curl http://localhost:8080/api/v1/health
```

### 2. Verificar que las Imágenes se Suben
```bash
# Después de subir una imagen, verificar que existe
curl http://localhost:8080/uploads/nombre-imagen.jpg
```

### 3. Verificar URL en la App
Agregar logs temporales en `NetworkImageWithFallback`:

```dart
@override
Widget build(BuildContext context) {
  final fullUrl = AppConfig.getImageUrl(imageUrl);
  print('🖼️ Loading image from: $fullUrl'); // LOG TEMPORAL
  
  return Image.network(fullUrl, ...);
}
```

### 4. Verificar Respuesta del Backend
Agregar logs en `MediaService`:

```dart
final response = await http.Response.fromStream(streamedResponse);
print('📤 Upload response: ${response.body}'); // LOG TEMPORAL
```

---

## ⚙️ Configuración Recomendada

### Para Desarrollo con Emulador Android

**1. Actualizar `lib/core/config/app_config.dart`:**
```dart
static const String baseUrl = 'http://10.0.2.2:8080';
```

**2. Actualizar `lib/core/constants/app_constants.dart`:**
```dart
static const String authBaseUrl = 'http://10.0.2.2:8080/api/v1/';
```

**3. Verificar que el backend acepta conexiones desde 10.0.2.2:**
- El backend debe estar configurado para aceptar CORS
- El backend debe escuchar en `0.0.0.0:8080` (no solo `localhost:8080`)

---

## 🐛 Troubleshooting Adicional

### Problema: "Connection Refused"

**Causa:** El backend no está corriendo o no acepta conexiones externas

**Solución:**
1. Verificar que el backend está corriendo
2. Verificar que el backend escucha en `0.0.0.0:8080`
3. Verificar firewall de Windows/Mac

### Problema: "Network Image Failed to Load"

**Causa:** URL incorrecta o imagen no existe

**Solución:**
1. Verificar la URL completa en los logs
2. Intentar abrir la URL en el navegador
3. Verificar que la imagen existe en el servidor

### Problema: "CORS Error"

**Causa:** El backend no permite peticiones desde el origen de la app

**Solución:**
Configurar CORS en el backend (Spring Boot):
```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*");
    }
}
```

### Problema: Imágenes Muy Lentas

**Causa:** Imágenes muy grandes sin optimización

**Solución:**
1. Comprimir imágenes antes de subir
2. Implementar thumbnails en el backend
3. Usar caché de imágenes

---

## 📋 Checklist de Verificación

Antes de reportar un problema con imágenes, verificar:

- [ ] Backend está corriendo en puerto 8080
- [ ] URL base es correcta para tu plataforma (10.0.2.2 para Android)
- [ ] Permisos agregados en AndroidManifest.xml
- [ ] image_picker está en pubspec.yaml
- [ ] `flutter pub get` ejecutado después de agregar permisos
- [ ] App reiniciada después de cambios en AndroidManifest
- [ ] Backend acepta CORS
- [ ] Imágenes existen en el servidor
- [ ] URLs se construyen correctamente (verificar logs)

---

## 🔄 Pasos para Reiniciar Después de Cambios

Después de modificar AndroidManifest.xml o agregar permisos:

```bash
# 1. Detener la app
# 2. Limpiar build
flutter clean

# 3. Obtener dependencias
flutter pub get

# 4. Reconstruir y ejecutar
flutter run
```

---

## 📝 Ejemplo de Flujo Completo

### 1. Usuario Selecciona Imagen
```dart
final images = await _imagePicker.pickMultiImage();
// ✅ Ahora funciona con permisos correctos
```

### 2. Upload al Backend
```dart
final result = await mediaService.uploadFile(file: file);
// Backend responde: { "url": "/uploads/img123.jpg" }
// MediaService construye: http://10.0.2.2:8080/uploads/img123.jpg
```

### 3. Guardar en Base de Datos
```dart
await portfolioService.createPortfolio(
  urlImagen: uploadedUrl, // http://10.0.2.2:8080/uploads/img123.jpg
);
```

### 4. Visualizar Imagen
```dart
NetworkImageWithFallback(
  imageUrl: portfolio.urlImagen,
  // Widget construye URL correcta automáticamente
)
```

---

## 🎯 Resultado Esperado

Después de aplicar estas soluciones:

✅ **Selección de Imágenes:** Funciona sin errores  
✅ **Upload de Imágenes:** Se suben correctamente al backend  
✅ **Visualización:** Las imágenes se muestran correctamente  
✅ **Fallback:** Si falla, muestra icono de error o iniciales  
✅ **Loading:** Muestra indicador de carga mientras descarga  

---

## 📞 Si Aún No Funciona

1. **Verificar logs de la app:**
   ```bash
   flutter logs
   ```

2. **Verificar logs del backend:**
   - Revisar consola del backend
   - Verificar que las peticiones llegan

3. **Probar URL manualmente:**
   - Copiar URL de los logs
   - Abrir en navegador
   - Verificar que la imagen se descarga

4. **Verificar red:**
   - Emulador y backend en la misma máquina
   - Firewall no bloquea puerto 8080
   - Backend escucha en 0.0.0.0:8080

---

**Fecha de Solución:** 27 de Noviembre, 2025  
**Estado:** ✅ Solucionado  
**Plataforma:** Android Emulator
