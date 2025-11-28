# Design Document - Complete Features

## Overview

Este documento describe el diseño técnico para completar todas las funcionalidades principales de ArtCollab Mobile App, manteniendo el sistema de diseño elegante ya establecido y las buenas prácticas de Flutter. El enfoque principal está en las funcionalidades de gestión de empleos (proyectos) para ambos roles, seguido de funcionalidades sociales y de perfil.

## Architecture

### Arquitectura General

La aplicación sigue una arquitectura limpia (Clean Architecture) con separación clara de responsabilidades:

```
lib/
├── core/
│   ├── config/          # Configuración (URLs, constantes)
│   ├── theme/           # Sistema de diseño (AppTheme)
│   ├── network/         # HTTP Client, Socket Client
│   └── storage/         # Almacenamiento local (tokens, preferencias)
├── features/
│   ├── projects/        # Gestión de empleos/proyectos
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── remote/  # ProjectService (API calls)
│   │   │   └── repository/
│   │   └── presentation/
│   │       ├── blocs/
│   │       ├── pages/
│   │       └── widgets/
│   ├── portfolio/       # Gestión de portafolios
│   ├── users/           # Perfiles y seguimiento
│   └── chat/            # Sistema de mensajería
└── shared/
    └── widgets/         # Widgets reutilizables (ElegantButton, etc.)
```

### Patrón BLoC

Todas las funcionalidades utilizan el patrón BLoC (Business Logic Component) para gestión de estado:

- **Events**: Acciones del usuario
- **States**: Estados de la UI
- **BLoC**: Lógica de negocio que transforma eventos en estados

### Comunicación con Backend

- **HTTP**: Para operaciones CRUD (GET, POST, PUT, DELETE)
- **Socket.IO**: Para actualizaciones en tiempo real (opcional para chat)
- **Firebase**: Alternativa para chat en tiempo real (opcional)

## Components and Interfaces

### 1. Gestión de Empleos (Proyectos)

#### CreateJobPage
Formulario completo para crear empleos con diseño elegante.

**Widgets utilizados:**
- `ElegantFormField` - Campos de texto con validación
- `ElegantButton` - Botón de crear con loading state
- `ImagePickerWidget` - Selector de imágenes de referencia

**Campos:**
- Título (requerido)
- Descripción (requerido)
- Categoría (requerido)
- Presupuesto (requerido)
- Fecha límite (requerido)
- Imágenes de referencia (opcional, múltiples)

#### MyJobsPage
Lista de empleos publicados por el escritor con tabs y filtros.

**Tabs:**
- Todos
- Abiertos
- En Progreso
- Cerrados
- Finalizados

**Acciones:**
- Ver detalle
- Editar (solo si está abierto)
- Cerrar empleo
- Finalizar empleo
- Ver postulaciones

#### JobApplicationsPage
Lista de postulaciones para un empleo específico.

**Información mostrada:**
- Foto del ilustrador
- Nombre y especialidad
- Mensaje de postulación
- Fecha de postulación
- Estado (Pendiente, Aprobada, Rechazada)

**Acciones:**
- Ver perfil del ilustrador
- Aprobar postulación
- Rechazar postulación (con motivo opcional)

### 2. Gestión de Postulaciones (Ilustrador)

#### MyApplicationsPage
Lista de postulaciones del ilustrador con filtros por estado.

**Estados:**
- Todas
- Pendientes
- Aprobadas
- Rechazadas
- Canceladas

**Información mostrada:**
- Título del empleo
- Nombre del escritor
- Estado de la postulación
- Fecha de postulación
- Motivo de rechazo (si aplica)

**Acciones:**
- Ver detalle del empleo
- Cancelar postulación (solo si está pendiente)
- Iniciar chat (si está aprobada)

### 3. Edición de Perfil

#### EditProfilePage
Formulario para editar información del perfil.

**Campos comunes:**
- Foto de perfil
- Nombre completo
- Email (solo lectura)
- Teléfono
- Ubicación
- Descripción/Bio
- Redes sociales (Instagram, Twitter, Portfolio URL)

**Campos específicos para Ilustrador:**
- Especialidades (lista de tags)
- Portafolio destacado
- Años de experiencia

**Campos específicos para Escritor:**
- Géneros literarios
- Obras publicadas

### 4. Búsqueda de Usuarios

#### UserSearchPage
Página de búsqueda con resultados en tiempo real.

**Componentes:**
- Campo de búsqueda con debounce
- Lista de resultados con avatares
- Filtros por rol (Todos, Ilustradores, Escritores)
- Botón de seguir/siguiendo en cada resultado

### 5. Sistema de Seguimiento

#### FollowersPage / FollowingPage
Listas de seguidores y seguidos.

**Información mostrada:**
- Avatar
- Nombre
- Rol
- Botón de seguir/dejar de seguir
- Botón de ver perfil

### 6. Perfil de Otros Usuarios

#### UserProfilePage
Perfil público de otros usuarios.

**Secciones comunes:**
- Header con foto, nombre, rol
- Botones: Seguir, Mensaje
- Estadísticas: Seguidores, Seguidos, Posts
- Bio y descripción
- Redes sociales

**Secciones para Ilustrador:**
- Grid de portafolio
- Trabajos destacados
- Especialidades

**Secciones para Escritor:**
- Lista de empleos publicados
- Géneros literarios

### 7. Búsqueda de Empleos

#### JobSearchPage
Búsqueda avanzada de empleos con filtros.

**Filtros:**
- Texto libre (título y descripción)
- Categorías (múltiple selección)
- Rango de presupuesto (slider)
- Fecha de publicación
- Estado (solo abiertos por defecto)

**Ordenamiento:**
- Más recientes
- Presupuesto (mayor a menor)
- Presupuesto (menor a mayor)
- Fecha límite (próximos a vencer)

### 8. Gestión de Ilustraciones

#### ManageIllustrationsPage
CRUD completo de ilustraciones en el portafolio.

**Acciones:**
- Agregar ilustración (con múltiples imágenes)
- Editar ilustración
- Eliminar ilustración (con confirmación)
- Publicar/despublicar ilustración
- Reordenar ilustraciones (drag & drop)

#### AddIllustrationPage / EditIllustrationPage
Formularios para agregar/editar ilustraciones.

**Campos:**
- Título
- Descripción
- Categoría/Tags
- Imágenes (múltiples)
- Estado (Borrador/Publicada)

### 9. Página de Suscripciones

#### SubscriptionPage (Mejorada)
Página elegante con planes de suscripción.

**Planes:**
- Gratis
- Básico
- Premium
- Profesional

**Información por plan:**
- Precio mensual/anual
- Lista de beneficios
- Badge de "Más popular" o "Recomendado"
- Botón de suscripción

**Sección de suscripción actual:**
- Plan activo
- Fecha de renovación
- Botón de cancelar
- Botón de mejorar plan

### 10. Sistema de Chat Alternativo

#### Opciones de Implementación

**Opción A: Firebase Realtime Database / Firestore**
- Mensajería en tiempo real sin backend propio
- Notificaciones push con FCM
- Almacenamiento de archivos con Firebase Storage

**Opción B: Socket.IO Mejorado**
- Usar el Socket.IO existente
- Implementar eventos específicos para chat
- Mantener historial en backend

**Opción C: Híbrido**
- Firebase para mensajería en tiempo real
- Backend para historial y búsqueda
- Sincronización bidireccional

#### ChatPage (Mejorada)
Interfaz de chat con funcionalidades avanzadas.

**Funcionalidades:**
- Mensajes en tiempo real
- Indicador de "escribiendo..."
- Confirmación de lectura
- Envío de imágenes
- Historial de mensajes
- Búsqueda en conversación

## Data Models

### Job (Empleo/Proyecto)

```dart
class Job {
  final String id;
  final String title;
  final String description;
  final String category;
  final double budget;
  final DateTime deadline;
  final List<String> referenceImages;
  final String writerId;
  final String writerName;
  final JobStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int applicationsCount;
}

enum JobStatus {
  open,
  inProgress,
  closed,
  completed
}
```

### Application (Postulación)

```dart
class Application {
  final String id;
  final String jobId;
  final String illustratorId;
  final String illustratorName;
  final String illustratorPhoto;
  final String message;
  final ApplicationStatus status;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum ApplicationStatus {
  pending,
  approved,
  rejected,
  cancelled
}
```

### UserProfile (Perfil de Usuario)

```dart
class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String? photoUrl;
  final String? phone;
  final String? location;
  final String? bio;
  final UserRole role;
  final SocialLinks? socialLinks;
  final IllustratorProfile? illustratorProfile;
  final WriterProfile? writerProfile;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;
  final DateTime createdAt;
}

enum UserRole {
  illustrator,
  writer
}

class SocialLinks {
  final String? instagram;
  final String? twitter;
  final String? portfolioUrl;
}

class IllustratorProfile {
  final List<String> specialties;
  final String? featuredPortfolio;
  final int yearsOfExperience;
}

class WriterProfile {
  final List<String> genres;
  final List<String> publishedWorks;
}
```

### Follow (Seguimiento)

```dart
class Follow {
  final String id;
  final String followerId;
  final String followingId;
  final DateTime createdAt;
}
```

### Illustration (Ilustración)

```dart
class Illustration {
  final String id;
  final String portfolioId;
  final String title;
  final String description;
  final List<String> images;
  final List<String> tags;
  final IllustrationStatus status;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum IllustrationStatus {
  draft,
  published
}
```

### Subscription (Suscripción)

```dart
class Subscription {
  final String id;
  final String userId;
  final SubscriptionPlan plan;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? renewalDate;
  final double price;
  final BillingPeriod billingPeriod;
}

enum SubscriptionPlan {
  free,
  basic,
  premium,
  professional
}

enum SubscriptionStatus {
  active,
  cancelled,
  expired
}

enum BillingPeriod {
  monthly,
  yearly
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Image upload success
*For any* set of valid images, uploading them to the backend should return URLs for all images
**Validates: Requirements 1.2**

### Property 2: Job creation persistence
*For any* valid job data, creating a job should result in the job being retrievable from the backend
**Validates: Requirements 1.3**

### Property 3: Invalid data rejection
*For any* invalid job data (missing required fields, invalid formats), the system should reject the creation and show validation errors
**Validates: Requirements 1.4**

### Property 4: Job list consistency
*For any* user, after creating a job, the job should appear in their "Mis Empleos" list
**Validates: Requirements 1.5**

### Property 5: User jobs completeness
*For any* writer, accessing "Mis Empleos" should return all jobs created by that writer
**Validates: Requirements 2.1**

### Property 6: Job closure state change
*For any* open job, closing it should change its status to closed and prevent new applications
**Validates: Requirements 2.3**

### Property 7: Job completion state change
*For any* job, finalizing it should change its status to completed
**Validates: Requirements 2.4**

### Property 8: Job update persistence
*For any* open job and valid updates, editing the job should persist the changes in the backend
**Validates: Requirements 2.5**

### Property 9: Applications completeness
*For any* job, viewing its applications should return all applications submitted for that job
**Validates: Requirements 3.1**

### Property 10: Application approval state change
*For any* pending application, approving it should change its status to approved and create a notification
**Validates: Requirements 3.3**

### Property 11: Application rejection with reason
*For any* pending application, rejecting it should allow an optional reason and change its status to rejected
**Validates: Requirements 3.4**

### Property 12: Chat creation on approval
*For any* approved application, a chat channel should exist between the writer and illustrator
**Validates: Requirements 3.5**

### Property 13: Profile photo upload
*For any* valid image, uploading it as profile photo should update the user's photoUrl
**Validates: Requirements 4.2**

### Property 14: Profile update persistence
*For any* valid profile data, updating the profile should persist the changes in the backend
**Validates: Requirements 4.3**

### Property 15: Profile validation
*For any* invalid profile data, the system should reject the update and show specific validation errors
**Validates: Requirements 4.4**

### Property 16: Role-specific fields
*For any* illustrator, the edit profile form should include illustrator-specific fields (specialties, portfolio)
**Validates: Requirements 4.5**

### Property 17: Search results filtering
*For any* search query, all returned users should match the query in their name or username
**Validates: Requirements 5.1**

### Property 18: Follow relationship creation
*For any* user A following user B, a follow relationship should exist in the backend
**Validates: Requirements 6.1**

### Property 19: Unfollow relationship deletion
*For any* user A unfollowing user B, the follow relationship should not exist in the backend
**Validates: Requirements 6.2**

### Property 20: Follow button state
*For any* profile being viewed, if the current user follows that profile, the button should show "Siguiendo"
**Validates: Requirements 6.3**

### Property 21: Followers list completeness
*For any* user, their followers list should contain all users who follow them
**Validates: Requirements 6.4**

### Property 22: Following list completeness
*For any* user, their following list should contain all users they follow
**Validates: Requirements 6.5**

### Property 23: Public profile data visibility
*For any* user viewing another user's profile, all public information should be displayed
**Validates: Requirements 7.1**

### Property 24: Illustrator profile content
*For any* illustrator profile, the portfolio and featured works should be displayed
**Validates: Requirements 7.2**

### Property 25: Writer profile content
*For any* writer profile, their published jobs should be displayed
**Validates: Requirements 7.3**

### Property 26: Own profile button state
*For any* user viewing their own profile, the edit button should be shown instead of follow button
**Validates: Requirements 7.5**

### Property 27: Job search text filtering
*For any* search query, all returned jobs should match the query in title or description
**Validates: Requirements 8.1**

### Property 28: Job category filtering
*For any* selected categories, all returned jobs should belong to one of the selected categories
**Validates: Requirements 8.2**

### Property 29: Job budget filtering
*For any* budget range, all returned jobs should have budget within the specified range
**Validates: Requirements 8.3**

### Property 30: Job sorting correctness
*For any* sort criterion (date, budget), the returned jobs should be ordered according to that criterion
**Validates: Requirements 8.4**

### Property 31: User applications completeness
*For any* illustrator, their applications page should show all applications they have submitted
**Validates: Requirements 9.1**

### Property 32: Application cancellation state change
*For any* pending application, cancelling it should change its status to cancelled
**Validates: Requirements 9.2**

### Property 33: Rejection reason display
*For any* rejected application with a reason, the reason should be displayed to the illustrator
**Validates: Requirements 9.4**

### Property 34: Application status filtering
*For any* selected status, all displayed applications should have that status
**Validates: Requirements 9.5**

### Property 35: Illustration creation persistence
*For any* valid illustration data with images, creating an illustration should persist it in the backend
**Validates: Requirements 10.1**

### Property 36: Illustration update persistence
*For any* illustration and valid updates, editing the illustration should persist the changes
**Validates: Requirements 10.2**

### Property 37: Illustration publication state change
*For any* draft illustration, publishing it should change its status to published and make it visible in the feed
**Validates: Requirements 10.4**

### Property 38: Illustration order persistence
*For any* reordering of illustrations, the new order should be persisted and maintained
**Validates: Requirements 10.5**

### Property 39: Active subscription display
*For any* user with an active subscription, the subscription page should display the current plan and renewal date
**Validates: Requirements 11.3**

### Property 40: Subscription cancellation state change
*For any* active subscription, cancelling it should change its status to cancelled
**Validates: Requirements 11.4**

### Property 41: Subscription upgrade calculation
*For any* subscription upgrade, the system should calculate the correct prorated amount
**Validates: Requirements 11.5**

### Property 42: Chat creation on application approval
*For any* approved application, a chat channel should be automatically created
**Validates: Requirements 12.1**

### Property 43: Message delivery
*For any* sent message, if the recipient is online, the message should be delivered immediately
**Validates: Requirements 12.4**

### Property 44: Notification creation
*For any* relevant action (like, comment, follow), a notification should be created in the backend
**Validates: Requirements 13.1**

### Property 45: Notification synchronization
*For any* user opening the app, all unread notifications should be synchronized
**Validates: Requirements 13.2**

### Property 46: Mark all as read
*For any* user marking all notifications as read, all notifications should have their status updated
**Validates: Requirements 13.4**

### Property 47: Unread badge display
*For any* user with unread notifications, a badge should be displayed on the notifications icon
**Validates: Requirements 13.5**

## Error Handling

### Estrategia General

1. **Network Errors**: Mostrar mensaje amigable y opción de reintentar
2. **Validation Errors**: Mostrar errores específicos en cada campo
3. **Server Errors**: Mostrar mensaje genérico y registrar error para debugging
4. **Timeout**: Mostrar mensaje de timeout y opción de reintentar

### Manejo por Capa

**Service Layer (HTTP)**:
```dart
try {
  final response = await http.post(url, body: data);
  if (response.statusCode == 200) {
    return Success(data);
  } else {
    return Failure(ServerException(response.body));
  }
} on SocketException {
  return Failure(NetworkException());
} on TimeoutException {
  return Failure(TimeoutException());
}
```

**BLoC Layer**:
```dart
on<CreateJobEvent>((event, emit) async {
  emit(CreateJobLoading());
  final result = await repository.createJob(event.job);
  result.fold(
    (failure) => emit(CreateJobError(failure.message)),
    (job) => emit(CreateJobSuccess(job)),
  );
});
```

**UI Layer**:
```dart
BlocListener<JobBloc, JobState>(
  listener: (context, state) {
    if (state is CreateJobError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is CreateJobSuccess) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Empleo creado exitosamente')),
      );
    }
  },
  child: ...,
)
```

## Testing Strategy

### Enfoque Dual de Testing

La estrategia de testing combina pruebas unitarias y pruebas basadas en propiedades para garantizar la correctitud del sistema:

- **Unit Tests**: Verifican ejemplos específicos, casos borde y condiciones de error
- **Property-Based Tests**: Verifican propiedades universales que deben cumplirse para todas las entradas

Juntas proporcionan cobertura completa: las pruebas unitarias detectan bugs concretos, las pruebas de propiedades verifican la correctitud general.

### Unit Testing

**Librería**: `flutter_test` (incluida en Flutter SDK)

**Áreas de cobertura**:
- Validación de formularios
- Transformación de datos (DTOs a modelos)
- Lógica de negocio en BLoCs
- Casos borde específicos (listas vacías, valores nulos)
- Manejo de errores

**Ejemplo**:
```dart
test('Job validation rejects empty title', () {
  final job = Job(title: '', description: 'Test', ...);
  expect(job.validate(), isFalse);
});
```

### Property-Based Testing

**Librería**: `test` package con generadores personalizados o `faker` para datos aleatorios

**Configuración**: Cada prueba de propiedad debe ejecutar un mínimo de 100 iteraciones

**Formato de tags**: Cada prueba de propiedad debe incluir un comentario que referencie explícitamente la propiedad de correctitud del documento de diseño:
```dart
// Feature: complete-features, Property 2: Job creation persistence
test('created jobs are retrievable', () { ... });
```

**Áreas de cobertura**:
- Persistencia de datos (crear y recuperar)
- Filtrado y búsqueda (resultados coinciden con criterios)
- Cambios de estado (transiciones válidas)
- Relaciones entre entidades (consistencia)

**Ejemplo**:
```dart
// Feature: complete-features, Property 27: Job search text filtering
test('search results match query', () {
  for (int i = 0; i < 100; i++) {
    final jobs = generateRandomJobs();
    final query = generateRandomQuery();
    final results = searchJobs(jobs, query);
    
    expect(
      results.every((job) => 
        job.title.contains(query) || 
        job.description.contains(query)
      ),
      isTrue,
    );
  }
});
```

### Integration Testing

**Librería**: `integration_test` (Flutter)

**Áreas de cobertura**:
- Flujos completos de usuario (crear empleo → ver en lista)
- Navegación entre pantallas
- Interacción con backend real (en ambiente de testing)

### Widget Testing

**Librería**: `flutter_test`

**Áreas de cobertura**:
- Renderizado correcto de widgets
- Interacción con widgets (tap, scroll, input)
- Estados de loading y error

## Implementation Notes

### Prioridades de Implementación

**Fase 1 - Funcionalidades Principales (Alta Prioridad)**:
1. Crear Empleo (CreateJobPage)
2. Gestión de Mis Empleos (MyJobsPage)
3. Gestión de Postulaciones - Escritor (JobApplicationsPage)
4. Edición de Perfil (EditProfilePage)
5. Búsqueda de Empleos (JobSearchPage)
6. Gestión de Postulaciones - Ilustrador (MyApplicationsPage)
7. Gestión de Ilustraciones (ManageIllustrationsPage)

**Fase 2 - Funcionalidades Sociales (Media Prioridad)**:
8. Búsqueda de Usuarios (UserSearchPage)
9. Sistema de Seguimiento (FollowersPage, FollowingPage)
10. Perfil de Otros Usuarios (UserProfilePage)
11. Página de Suscripciones Mejorada

**Fase 3 - Funcionalidades Avanzadas (Baja Prioridad)**:
12. Sistema de Chat Alternativo
13. Notificaciones Mejoradas

### Consideraciones de Diseño

1. **Consistencia Visual**: Usar siempre los widgets del sistema de diseño (ElegantButton, ElegantCard, ElegantFormField)
2. **Responsive**: Todas las páginas deben adaptarse a diferentes tamaños de pantalla
3. **Loading States**: Mostrar indicadores de carga durante operaciones asíncronas
4. **Empty States**: Diseñar estados vacíos informativos con call-to-action
5. **Error States**: Mensajes de error claros con opciones de recuperación

### Reutilización de Código

**Widgets Compartidos**:
- `NetworkImageWithFallback` - Para todas las imágenes de red
- `UserAvatar` - Para avatares de usuarios
- `ElegantCard` - Para tarjetas de contenido
- `ElegantButton` - Para todos los botones
- `ElegantFormField` - Para todos los campos de formulario
- `LoadingIndicator` - Indicador de carga consistente
- `EmptyState` - Estado vacío reutilizable

**Utilidades**:
- `DateFormatter` - Formateo consistente de fechas
- `CurrencyFormatter` - Formateo de moneda
- `Validators` - Validaciones comunes
- `ImagePicker` - Selector de imágenes reutilizable

### Optimizaciones

1. **Caché de Imágenes**: Usar `cached_network_image` para cachear imágenes
2. **Paginación**: Implementar scroll infinito para listas largas
3. **Debounce**: En búsquedas en tiempo real (300ms)
4. **Lazy Loading**: Cargar datos solo cuando son necesarios
5. **State Management**: Usar BLoC para evitar rebuilds innecesarios

### Alternativas para Chat

**Recomendación**: Firebase Realtime Database + FCM

**Ventajas**:
- Mensajería en tiempo real sin servidor propio
- Notificaciones push integradas
- Escalable y confiable
- Fácil de implementar

**Implementación**:
```dart
// Configuración
firebase_core: ^2.24.0
firebase_database: ^10.4.0
firebase_messaging: ^14.7.6

// Estructura de datos
/chats
  /{chatId}
    /messages
      /{messageId}
        - senderId
        - text
        - timestamp
        - read
    /participants
      - userId1
      - userId2
```

**Alternativa**: Socket.IO con eventos específicos
- Usar el Socket.IO existente
- Implementar eventos: `chat:message`, `chat:typing`, `chat:read`
- Mantener historial en backend

