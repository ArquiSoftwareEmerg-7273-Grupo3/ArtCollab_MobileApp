# ✅ Checklist Pre-Compilación

## 📋 Antes de Ejecutar `flutter run`

### 1. Backend Services ✓

- [ ] **API Gateway** corriendo en puerto 8080
  ```bash
  curl http://localhost:8080/actuator/health
  # Debe responder: {"status":"UP"}
  ```

- [ ] **Auth Service** corriendo
  ```bash
  curl http://localhost:8080/api/v1/authentication/health
  ```

- [ ] **Feed Service** corriendo
  ```bash
  curl http://localhost:8080/api/v1/posts?page=0&size=1
  ```

### 2. Flutter Environment ✓

- [ ] Flutter instalado correctamente
  ```bash
  flutter doctor
  # Todos los checks deben estar en verde ✓
  ```

- [ ] Dependencias instaladas
  ```bash
  cd ArtCollab_MobileApp
  flutter pub get
  # Debe completar sin errores
  ```

- [ ] Pruebas pasando
  ```bash
  flutter test
  # Debe mostrar: All tests passed!
  ```

### 3. Configuración de Red ✓

- [ ] **Para Emulador Android:**
  - URL configurada: `http://10.0.2.2:8080/api/v1/`
  - Archivo: `lib/core/constants/app_constants.dart`

- [ ] **Para Dispositivo Físico:**
  - Encuentra tu IP local:
    ```bash
    # Windows
    ipconfig
    # Busca "IPv4 Address"
    
    # Mac/Linux
    ifconfig
    # Busca "inet"
    ```
  - Actualiza URL: `http://TU_IP:8080/api/v1/`
  - Ejemplo: `http://192.168.1.100:8080/api/v1/`

### 4. Dispositivo/Emulador ✓

- [ ] Dispositivo conectado o emulador iniciado
  ```bash
  flutter devices
  # Debe mostrar al menos un dispositivo
  ```

- [ ] Modo desarrollador activado (dispositivo físico)
- [ ] Depuración USB activada (dispositivo físico)

## 🚀 Ejecutar la Aplicación

Una vez completado el checklist:

```bash
cd ArtCollab_MobileApp
flutter run
```

## 🔍 Verificación Post-Inicio

### En la Terminal de Flutter:

Deberías ver:
```
✓ Built build/app/outputs/flutter-apk/app-debug.apk
Launching lib/main.dart on Android SDK built for x86 in debug mode...
Running Gradle task 'assembleDebug'...
✓ Built build/app/outputs/flutter-apk/app.apk in 45.3s
Installing build/app/outputs/flutter-apk/app.apk...
Debug service listening on ws://127.0.0.1:xxxxx
```

### En la Aplicación:

1. **Pantalla de Login aparece** ✓
2. **Puedes registrarte/iniciar sesión** ✓
3. **Ves el feed de posts** ✓
4. **Puedes crear un post** ✓

### En los Logs:

Busca estos mensajes:
```
✅ Token saved successfully
🔌 Socket.IO connected
📤 Sending request to: http://10.0.2.2:8080/api/v1/posts
✅ Response received: 200
```

## 🐛 Si Algo Falla

### Error: "Unable to connect"

**Checklist:**
- [ ] Backend corriendo: `curl http://localhost:8080/actuator/health`
- [ ] URL correcta en `app_constants.dart`
- [ ] Firewall no bloqueando el puerto 8080
- [ ] Para emulador: usando `10.0.2.2` no `localhost`
- [ ] Para dispositivo: usando IP local, no `localhost`

**Solución rápida:**
```bash
# Reinicia el API Gateway
cd api-gateway
./mvnw spring-boot:run
```

### Error: "No devices found"

**Checklist:**
- [ ] Emulador iniciado o dispositivo conectado
- [ ] USB debugging activado (dispositivo físico)
- [ ] Drivers instalados (Windows)

**Solución rápida:**
```bash
# Ver dispositivos
flutter devices

# Reiniciar ADB (Android)
adb kill-server
adb start-server
flutter devices
```

### Error: "Gradle build failed"

**Solución:**
```bash
cd ArtCollab_MobileApp
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

### Error: "Session expired"

**Solución:**
- Esto es normal si el token JWT expiró
- Simplemente cierra sesión y vuelve a iniciar sesión
- El nuevo token se guardará automáticamente

## 📊 Métricas de Éxito

### ✅ Compilación Exitosa:
- Tiempo de compilación: ~30-60 segundos
- Sin errores en la terminal
- App se instala en el dispositivo
- Pantalla de login aparece

### ✅ Conexión Backend Exitosa:
- Login funciona
- Posts se cargan
- Puedes crear posts
- Comentarios y reacciones funcionan

### ✅ Tiempo Real Funciona:
- Socket.IO conectado (ver logs)
- Actualizaciones automáticas de posts
- Sin necesidad de refrescar manualmente

## 🎯 Flujo de Prueba Recomendado

1. **Registro/Login** (2 min)
   - Crea una cuenta nueva
   - Inicia sesión
   - Verifica que el token se guarde

2. **Feed** (3 min)
   - Ve la lista de posts
   - Scroll para cargar más (paginación)
   - Verifica que los posts se muestren correctamente

3. **Crear Post** (2 min)
   - Crea un post con texto
   - Crea un post con imagen
   - Verifica que aparezca en el feed

4. **Interacciones** (3 min)
   - Agrega un comentario
   - Dale like a un post
   - Haz un repost
   - Elimina tu post

5. **Tiempo Real** (2 min)
   - Abre la app en otro dispositivo/emulador
   - Crea un post en uno
   - Verifica que aparezca en el otro

**Tiempo total de prueba: ~12 minutos**

## 📝 Notas Finales

- **Primera compilación:** Puede tardar 2-3 minutos
- **Compilaciones siguientes:** ~30 segundos con hot reload
- **Hot reload:** Presiona `r` para ver cambios sin reiniciar
- **Hot restart:** Presiona `R` para reiniciar completamente
- **Salir:** Presiona `q` en la terminal

## 🎉 ¡Listo para Compilar!

Si completaste todos los checks, ejecuta:

```bash
cd ArtCollab_MobileApp
flutter run
```

**¡Disfruta probando la aplicación!** 🚀

---

**Documentación adicional:**
- `PASOS_RAPIDOS.md` - Guía rápida de 5 minutos
- `GUIA_COMPILACION.md` - Guía completa y detallada
- `TESTING_GUIDE.md` - Guía de pruebas
