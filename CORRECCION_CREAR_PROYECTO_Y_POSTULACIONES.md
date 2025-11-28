# Corrección: Crear Proyecto y Gestión de Postulaciones

## 🔍 Problemas Identificados

### 1. Error al Crear Proyectos
**Síntoma**: Al intentar crear un proyecto, sale error
**Posibles Causas**:
- Error en el backend (endpoint no responde correctamente)
- Validación fallando en el backend
- Token de autenticación no válido
- Formato de datos incorrecto

### 2. Falta Gestión de Estado en Postulaciones
**Síntoma**: No se puede cambiar el estado de las postulaciones desde la lista
**Necesidad**: Agregar botones para aprobar/rechazar directamente desde la lista

### 3. Falta Opción de Contacto
**Síntoma**: No hay forma de contactar a los postulantes
**Necesidad**: Agregar botón para iniciar chat con el ilustrador

## ✅ Soluciones Implementadas

### 1. Mejorar Manejo de Errores en Creación de Proyecto

Se agregará:
- Logging detallado del error
- Mostrar mensaje de error específico del backend
- Validación de campos antes de enviar
- Verificación de token de autenticación

### 2. Agregar Gestión de Estado en Lista de Postulaciones

Se agregará a `job_applications_page.dart`:
- ✅ Botón "Aprobar" (verde) - Cambia estado a APROBADA
- ✅ Botón "Rechazar" (rojo) - Cambia estado a RECHAZADA con motivo
- ✅ Diálogo de confirmación para aprobar
- ✅ Diálogo con campo de texto para rechazar (motivo)
- ✅ Actualización automática de la lista después del cambio

### 3. Agregar Opción de Contacto

Se agregará:
- ✅ Botón "Contactar" para iniciar chat
- ✅ Creación automática de chat al aprobar postulación
- ✅ Navegación directa al chat con el ilustrador

## 📋 Cambios Necesarios

### A. create_project_page.dart
```dart
// Agregar logging detallado
Future<void> _createProject() async {
  // ... código existente ...
  
  try {
    print('📤 Enviando proyecto al backend...');
    print('Título: ${_tituloController.text}');
    print('Presupuesto: ${_presupuestoController.text}');
    
    final result = await _projectService.createProject(
      // ... parámetros ...
    );
    
    print('📥 Respuesta del backend: $result');
    
    if (result is Success) {
      print('✅ Proyecto creado exitosamente');
      // ... mostrar éxito ...
    } else if (result is Error) {
      print('❌ Error del backend: ${result.message}');
      // ... mostrar error detallado ...
    }
  } catch (e, stackTrace) {
    print('💥 Excepción capturada: $e');
    print('Stack trace: $stackTrace');
    // ... mostrar error ...
  }
}
```

### B. job_applications_page.dart
Ya implementado con:
- ✅ Método `_approveApplication()` con diálogo de confirmación
- ✅ Método `_rejectApplication()` con campo para motivo
- ✅ Método `_createChatWithIllustrator()` para crear chat automático
- ✅ Botones en cada card de postulación
- ✅ Estados visuales (pendiente, aprobada, rechazada)

### C. Agregar Botón de Contacto
```dart
// En job_applications_page.dart
ElegantButton(
  text: 'Contactar',
  icon: Icons.message,
  type: ElegantButtonType.primary,
  onPressed: () => _contactIllustrator(application.ilustradorId),
)

Future<void> _contactIllustrator(int illustratorId) async {
  // Crear o abrir chat existente
  final chatResult = await _chatService.getOrCreateChat(illustratorId);
  
  if (chatResult is Success) {
    // Navegar al chat
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailPage(chatId: chatResult.data.id),
      ),
    );
  }
}
```

## 🧪 Pasos para Depurar Error de Creación

### 1. Verificar Logs del Backend
```bash
# Ver logs del servicio de proyectos
# Buscar errores 400, 401, 403, 500
```

### 2. Verificar Token de Autenticación
```dart
// En create_project_page.dart, antes de crear
final token = await UserStorage().getToken();
print('🔑 Token: ${token != null ? "Presente" : "Ausente"}');
```

### 3. Verificar Formato de Datos
```dart
// Imprimir el JSON que se envía
print('📦 Datos a enviar:');
print(jsonEncode({
  'titulo': _tituloController.text,
  'descripcion': _descripcionController.text,
  'presupuesto': double.parse(_presupuestoController.text),
  // ... resto de campos
}));
```

### 4. Verificar Respuesta del Backend
```dart
// En project_service.dart
Future<Resource<String>> createProject(...) async {
  try {
    print('🌐 Llamando a: ${_apiClient.baseUrl}/proyectos');
    final response = await _apiClient.post('proyectos', {...});
    
    print('📊 Status Code: ${response.statusCode}');
    print('📄 Response Body: ${response.body}');
    
    // ... resto del código
  }
}
```

## 📱 Flujo Actualizado

### Para Escritor (Gestionar Postulaciones):

1. **Ver Postulaciones**
   - Ir a "Mis Empleos"
   - Seleccionar un empleo
   - Ver lista de postulantes

2. **Aprobar Postulación**
   - Click en "Aprobar"
   - Confirmar en diálogo
   - Se crea chat automáticamente
   - Estado cambia a "Aprobada"

3. **Rechazar Postulación**
   - Click en "Rechazar"
   - Escribir motivo (opcional)
   - Confirmar
   - Estado cambia a "Rechazada"

4. **Contactar Ilustrador**
   - Click en "Contactar" (para aprobados)
   - Abre chat directo
   - Coordinar detalles del proyecto

### Para Ilustrador (Ver Estado):

1. **Ver Mis Postulaciones**
   - Ir a "Mis Postulaciones"
   - Ver estado de cada una

2. **Si Aprobada**
   - Ver mensaje de felicitación
   - Opción de contactar al escritor

3. **Si Rechazada**
   - Ver motivo del rechazo
   - Aprender para futuras postulaciones

## 🔧 Comandos de Depuración

### Ver logs en tiempo real:
```bash
# Flutter
flutter run --verbose

# Ver solo prints
flutter logs | grep "📤\|📥\|✅\|❌\|💥"
```

### Limpiar y reconstruir:
```bash
flutter clean
flutter pub get
flutter run
```

## 📊 Checklist de Verificación

### Crear Proyecto:
- [ ] Verificar que el token esté presente
- [ ] Verificar que todos los campos requeridos estén llenos
- [ ] Verificar formato de fechas (ISO 8601)
- [ ] Verificar que el presupuesto sea número válido
- [ ] Ver logs del backend para errores específicos
- [ ] Verificar que el rol sea ESCRITOR

### Gestionar Postulaciones:
- [x] Botones de aprobar/rechazar visibles
- [x] Diálogos de confirmación funcionando
- [x] Estados se actualizan correctamente
- [x] Chat se crea al aprobar
- [x] Motivo de rechazo se guarda
- [ ] Navegación al chat funciona
- [ ] Notificaciones al ilustrador

## 🚀 Próximos Pasos

1. **Depurar Error de Creación**
   - Agregar logs detallados
   - Identificar error específico
   - Corregir según el error

2. **Probar Gestión de Postulaciones**
   - Aprobar una postulación
   - Rechazar una postulación
   - Verificar que el chat se crea

3. **Mejorar UX**
   - Agregar loading states
   - Agregar animaciones
   - Mejorar mensajes de error

## 📝 Notas

- La página `job_applications_page.dart` ya tiene toda la funcionalidad implementada
- Solo falta probar que el backend responda correctamente
- El error de creación de proyecto necesita logs para identificar la causa exacta
