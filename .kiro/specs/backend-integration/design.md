# Design Document

## Overview

Este documento describe el diseño técnico para integrar la aplicación móvil Flutter ArtCollab con los microservicios backend existentes. La integración reemplazará los datos JSON estáticos actuales con llamadas HTTP reales a través del API Gateway, implementando autenticación JWT, comunicación en tiempo real con Socket.IO, y una arquitectura limpia que separe las responsabilidades en capas.

La aplicación móvil se conectará al API Gateway (puerto 8080) que enruta las peticiones a los siguientes microservicios:
- **auth-service**: Autenticación, usuarios, perfiles de ilustradores y escritores
- **feed-service**: Posts, comentarios, reacciones, reposts, y media
- **chat-service**: Mensajería entre usuarios
- **notification-service**: Notificaciones de actividades
- **portfolio-service**: Portafolios e ilustraciones
- **project-service**: Proyectos (empleos) y postulaciones

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Mobile App                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Presentation │  │ Presentation │  │ Presentation │      │
│  │   (BLoC)     │  │   (BLoC)     │  │   (BLoC)     │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                  │                  │              │
│  ┌──────▼──────────────────▼──────────────────▼───────┐    │
│  │              Domain Layer (Entities)               │    │
│  └──────┬──────────────────┬──────────────────┬───────┘    │
│         │                  │                  │              │
│  ┌──────▼───────┐  ┌──────▼───────┐  ┌──────▼───────┐     │
│  │ Repository   │  │ Repository   │  │ Repository   │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                  │                  │              │
│  ┌──────▼───────┐  ┌──────▼───────┐  ┌──────▼───────┐     │
│  │ Remote       │  │ Remote       │  │ Remote       │     │
│  │ Service      │  │ Service      │  │ Service      │     │
│  │ (HTTP/WS)    │  │ (HTTP/WS)    │  │ (HTTP/WS)    │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                  │                  │              │
│         └──────────────────┴──────────────────┘              │
│                            │                                 │
└────────────────────────────┼─────────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │   API Gateway   │
                    │   (Port 8080)   │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   ┌────▼────┐         ┌────▼────┐         ┌────▼────┐
   │  Auth   │         │  Feed   │         │  Chat   │
   │ Service │         │ Service │         │ Service │
   └─────────┘         └─────────┘         └─────────┘
```

### Layer Responsibilities

**Presentation Layer**
- UI components (Pages, Widgets)
- State management (BLoC/Cubit)
- User interaction handling
- Navigation

**Domain Layer**
- Business entities (User, Post, Chat, etc.)
- Business logic
- Independent of data sources

**Data Layer**
- Repositories (abstract data access)
- Remote services (HTTP clients, WebSocket)
- DTOs (Data Transfer Objects)
- Data transformation (DTO ↔ Entity)


## Components and Interfaces

### Core Infrastructure Components

#### 1. HTTP Client Configuration

**Purpose**: Centralized HTTP client with interceptors for authentication and error handling

**Location**: `lib/core/network/http_client.dart`

**Responsibilities**:
- Configure base URL (API Gateway)
- Add authentication headers automatically
- Handle common HTTP errors
- Implement timeout configuration
- Provide retry logic for failed requests

**Interface**:
```dart
class ApiClient {
  final http.Client _client;
  final TokenStorage _tokenStorage;
  
  Future<http.Response> get(String endpoint);
  Future<http.Response> post(String endpoint, Map<String, dynamic> body);
  Future<http.Response> put(String endpoint, Map<String, dynamic> body);
  Future<http.Response> delete(String endpoint);
  Future<http.Response> patch(String endpoint, Map<String, dynamic> body);
}
```

#### 2. Socket.IO Client

**Purpose**: Real-time communication for feed updates

**Location**: `lib/core/network/socket_client.dart`

**Responsibilities**:
- Establish WebSocket connection to feed service
- Listen for real-time events (new posts, reactions, comments)
- Emit events to server
- Handle connection/disconnection
- Automatic reconnection

**Interface**:
```dart
class SocketClient {
  void connect(String token);
  void disconnect();
  void on(String event, Function(dynamic) callback);
  void emit(String event, dynamic data);
  bool get isConnected;
}
```

#### 3. Token Storage

**Purpose**: Secure storage for JWT tokens

**Location**: `lib/core/storage/token_storage.dart`

**Responsibilities**:
- Store JWT token securely
- Retrieve token for authenticated requests
- Clear token on logout
- Check token expiration

**Interface**:
```dart
class TokenStorage {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<bool> hasValidToken();
}
```


### Feature-Specific Components

#### Authentication Feature

**Remote Service**: `lib/features/auth/data/remote/auth_service.dart`
- `POST /api/v1/authentication/sign-in` - Login
- `POST /api/v1/authentication/sign-up` - Register

**DTOs**:
- `SignInRequestDto`: {username, password}
- `SignUpRequestDto`: {username, password, ubicacion, nombres, apellidos, telefono, foto, descripcion, fechaNacimiento, redesSociales}
- `AuthenticatedUserDto`: {id, username, token, role}
- `UserDto`: {id, username, role}

**Repository**: `lib/features/auth/data/repository/auth_repository.dart`
- `Future<Resource<User>> signIn(String username, String password)`
- `Future<Resource<User>> signUp(SignUpData data)`

**Entities**: `lib/features/auth/domain/entities/user.dart`
- User: {id, username, role}

#### Feed Feature

**Remote Service**: `lib/features/feed/data/remote/feed_service.dart`
- `GET /api/v1/posts` - Get posts with pagination
- `POST /api/v1/posts` - Create post
- `DELETE /api/v1/posts/{postId}` - Delete post
- `POST /api/v1/posts/{postId}/comments` - Add comment
- `POST /api/v1/posts/{postId}/reactions` - Add reaction
- `DELETE /api/v1/posts/{postId}/reactions` - Remove reaction
- `POST /api/v1/posts/{postId}/reposts` - Repost
- `POST /api/v1/media/upload` - Upload media

**Socket Events**:
- Listen: `post:created`, `post:deleted`, `post:updated`
- Emit: `post:view`

**DTOs**:
- `PostDto`: {id, authorId, content, tags, mediaUrls, createdAt, updatedAt, viewCount, commentCount, reactionCount, repostCount}
- `CommentDto`: {id, postId, authorId, content, createdAt}
- `ReactionDto`: {id, postId, userId, reactionType}
- `MediaDto`: {id, url, originalFilename, mediaType, fileSize}

**Repository**: `lib/features/feed/data/repository/feed_repository.dart`
- `Future<Resource<List<Post>>> getPosts(int page, int size)`
- `Future<Resource<Post>> createPost(String content, List<String> tags, List<File> media)`
- `Future<Resource<void>> deletePost(int postId)`
- `Future<Resource<Comment>> addComment(int postId, String content)`
- `Future<Resource<void>> addReaction(int postId, String reactionType)`

**Entities**: `lib/features/feed/domain/entities/`
- Post: {id, authorId, content, tags, mediaUrls, createdAt, stats}
- Comment: {id, postId, authorId, content, createdAt}


#### Chat Feature

**Remote Service**: `lib/features/chat/data/remote/chat_service.dart`
- `POST /api/v1/chats` - Create chat
- `GET /api/v1/chats/{chatId}` - Get chat details
- `GET /api/v1/chats/{chatId}/mensajes` - Get messages
- `POST /api/v1/chats/{chatId}/mensajes` - Send message
- `GET /api/v1/chats` - Get all chats

**DTOs**:
- `ChatDto`: {id, participantIds, createdAt}
- `MessageDto`: {id, chatId, remitenteId, contenido, fechaEnvio}
- `CreateChatRequestDto`: {participantIds}
- `SendMessageRequestDto`: {remitenteId, contenido}

**Repository**: `lib/features/chat/data/repository/chat_repository.dart`
- `Future<Resource<Chat>> createChat(List<int> participantIds)`
- `Future<Resource<List<Message>>> getMessages(int chatId)`
- `Future<Resource<void>> sendMessage(int chatId, String content)`
- `Future<Resource<List<Chat>>> getAllChats()`

**Entities**: `lib/features/chat/domain/entities/`
- Chat: {id, participantIds, lastMessage, createdAt}
- Message: {id, chatId, senderId, content, timestamp}

#### Notifications Feature

**Remote Service**: `lib/features/notifications/data/remote/notification_service.dart`
- `GET /api/v1/notifications?userId={userId}` - Get all notifications
- `GET /api/v1/notifications/unread?userId={userId}` - Get unread notifications
- `PATCH /api/v1/notifications/{notificationId}/read` - Mark as read

**DTOs**:
- `NotificationDto`: {id, userId, type, message, relatedEntityId, isRead, createdAt}
- `MarkAsReadRequestDto`: {isRead}

**Repository**: `lib/features/notifications/data/repository/notification_repository.dart`
- `Future<Resource<List<Notification>>> getNotifications(int userId)`
- `Future<Resource<List<Notification>>> getUnreadNotifications(int userId)`
- `Future<Resource<void>> markAsRead(int notificationId)`

**Entities**: `lib/features/notifications/domain/entities/`
- Notification: {id, userId, type, message, relatedEntityId, isRead, createdAt}


#### Portfolio Feature

**Remote Service**: `lib/features/portfolio/data/remote/portfolio_service.dart`
- `POST /api/v1/portafolios` - Create portfolio (requires Authorization header)
- `GET /api/v1/portafolios/mi-portafolio` - Get my portfolio (requires Authorization header)
- `GET /api/v1/portafolios/ilustrador/{ilustradorId}` - Get portfolio by illustrator
- `POST /api/v1/ilustraciones/publicar/{ilustradorId}` - Publish illustration
- `GET /api/v1/ilustraciones/ilustrador/{ilustradorId}/publicadas` - Get published illustrations
- `DELETE /api/v1/ilustraciones/{ilustracionId}` - Delete illustration

**DTOs**:
- `PortfolioDto`: {id, ilustradorId, nombre, descripcion, ilustraciones}
- `IllustrationDto`: {id, titulo, descripcion, imagenUrl, categoriaId, fechaPublicacion}
- `CreatePortfolioRequestDto`: {nombre, descripcion}
- `PublishIllustrationRequestDto`: {titulo, descripcion, imagenUrl, categoriaId}

**Repository**: `lib/features/portfolio/data/repository/portfolio_repository.dart`
- `Future<Resource<Portfolio>> createPortfolio(String nombre, String descripcion)`
- `Future<Resource<Portfolio>> getMyPortfolio()`
- `Future<Resource<List<Illustration>>> getIllustrations(int ilustradorId)`
- `Future<Resource<Illustration>> publishIllustration(IllustrationData data)`
- `Future<Resource<void>> deleteIllustration(int ilustracionId)`

**Entities**: `lib/features/portfolio/domain/entities/`
- Portfolio: {id, ilustradorId, nombre, descripcion, illustrations}
- Illustration: {id, titulo, descripcion, imagenUrl, categoriaId, fechaPublicacion}

#### Projects Feature

**Remote Service**: `lib/features/projects/data/remote/project_service.dart`
- `POST /api/v1/proyectos` - Create project (requires Authorization header)
- `GET /api/v1/proyectos` - Get all projects
- `GET /api/v1/proyectos/{id}` - Get project by ID
- `GET /api/v1/proyectos/mis-proyectos` - Get my projects (requires Authorization header)
- `POST /api/v1/postulaciones/postular/proyecto/{proyectoId}` - Apply to project
- `GET /api/v1/postulaciones/mis-postulaciones` - Get my applications
- `GET /api/v1/postulaciones/proyectoId/{proyectoId}` - Get applications for project
- `PATCH /api/v1/postulaciones/{id}/aprobar` - Approve application
- `PATCH /api/v1/postulaciones/{id}/rechazar` - Reject application

**DTOs**:
- `ProjectDto`: {id, escritorId, titulo, descripcion, especialidad, modalidad, contrato, presupuesto, estado, fechaCreacion}
- `ApplicationDto`: {id, proyectoId, ilustradorId, mensaje, estado, fechaPostulacion}
- `CreateProjectRequestDto`: {titulo, descripcion, especialidad, modalidad, contrato, presupuesto}
- `CreateApplicationRequestDto`: {mensaje}

**Repository**: `lib/features/projects/data/repository/project_repository.dart`
- `Future<Resource<Project>> createProject(ProjectData data)`
- `Future<Resource<List<Project>>> getAllProjects()`
- `Future<Resource<Project>> getProjectById(int id)`
- `Future<Resource<void>> applyToProject(int projectId, String mensaje)`
- `Future<Resource<List<Application>>> getMyApplications()`

**Entities**: `lib/features/projects/domain/entities/`
- Project: {id, escritorId, titulo, descripcion, especialidad, modalidad, contrato, presupuesto, estado}
- Application: {id, proyectoId, ilustradorId, mensaje, estado, fechaPostulacion}


#### User Profiles Feature

**Remote Service**: `lib/features/users/data/remote/user_service.dart`
- `GET /api/v1/users` - Get all users
- `GET /api/v1/users/{userId}` - Get user by ID
- `GET /api/v1/users/me` - Get current user (requires Authorization header)
- `POST /api/v1/ilustradores` - Create illustrator profile
- `GET /api/v1/ilustradores/by-user/{userId}` - Get illustrator by user ID
- `POST /api/v1/escritores` - Create writer profile
- `GET /api/v1/escritores/by-user/{userId}` - Get writer by user ID

**DTOs**:
- `UserDto`: {id, username, role}
- `IllustratorProfileDto`: {id, userId, especialidad, experiencia, portafolioUrl}
- `WriterProfileDto`: {id, userId, genero, experiencia, obrasPublicadas}
- `CreateIllustratorRequestDto`: {especialidad, experiencia, portafolioUrl}
- `CreateWriterRequestDto`: {genero, experiencia, obrasPublicadas}

**Repository**: `lib/features/users/data/repository/user_repository.dart`
- `Future<Resource<User>> getCurrentUser()`
- `Future<Resource<User>> getUserById(int userId)`
- `Future<Resource<List<User>>> getAllUsers()`
- `Future<Resource<IllustratorProfile>> createIllustratorProfile(ProfileData data)`
- `Future<Resource<WriterProfile>> createWriterProfile(ProfileData data)`

**Entities**: `lib/features/users/domain/entities/`
- User: {id, username, role, profile}
- IllustratorProfile: {id, userId, especialidad, experiencia}
- WriterProfile: {id, userId, genero, experiencia}

## Data Models

### Core Models

#### Resource<T>
Generic wrapper for API responses that encapsulates success/error states:
```dart
abstract class Resource<T> {}

class Success<T> extends Resource<T> {
  final T data;
  Success(this.data);
}

class Error<T> extends Resource<T> {
  final String message;
  Error(this.message);
}

class Loading<T> extends Resource<T> {}
```

#### API Response Structure
All backend responses follow consistent patterns:
- Success: HTTP 200/201 with data
- Client Error: HTTP 4xx with error message
- Server Error: HTTP 5xx with error message
- Authentication Error: HTTP 401 (triggers logout)


## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### HTTP Client Properties

Property 1: Header inclusion
*For any* HTTP request made by the system, the request should include Content-Type and Authorization headers (when authenticated)
**Validates: Requirements 1.2, 1.3**

Property 2: Token injection
*For any* authenticated HTTP request, when a JWT token exists in storage, the Authorization header should contain "Bearer {token}"
**Validates: Requirements 1.3**

Property 3: Network error handling
*For any* network error (timeout, connection failure), the system should return an Error resource with a user-friendly message
**Validates: Requirements 1.4**

Property 4: JSON parsing round-trip
*For any* valid JSON response from the backend, parsing to DTO and serializing back should preserve the data structure
**Validates: Requirements 1.5**

### Authentication Properties

Property 5: Authentication success token storage
*For any* successful authentication response containing a JWT token, the token should be stored and retrievable from TokenStorage
**Validates: Requirements 3.2**

Property 6: Authentication failure error messages
*For any* authentication failure (invalid credentials), the system should return an Error resource with a descriptive message
**Validates: Requirements 3.3**

Property 7: Registration creates user
*For any* valid registration data, submitting to the Auth Service should create a user and return a UserResource
**Validates: Requirements 3.4**

Property 8: DTO to Entity transformation
*For any* DTO received from the API, converting to domain entity and back to DTO should preserve all fields
**Validates: Requirements 11.5**


### Feed Properties

Property 9: Feed pagination
*For any* page number and size, requesting posts from the Feed Service should return at most 'size' posts
**Validates: Requirements 4.1**

Property 10: Post display completeness
*For any* post loaded from the Feed Service, the displayed post should include content, images, tags, and metadata fields
**Validates: Requirements 4.2**

Property 11: Post creation returns ID
*For any* valid post data (content, tags, media), creating a post should return a Success resource with a post ID
**Validates: Requirements 4.4**

Property 12: Post deletion removes from feed
*For any* post owned by the user, deleting the post should result in the post no longer appearing in subsequent feed requests
**Validates: Requirements 4.5**

Property 13: Real-time post updates
*For any* new post event received via Socket.IO, the feed UI should update to include the new post without manual refresh
**Validates: Requirements 4.8**

Property 14: Comment association
*For any* valid comment on a post, creating the comment should result in the comment being associated with the correct post ID
**Validates: Requirements 5.1**

Property 15: Reaction count increment
*For any* post, adding a reaction should increase the reaction count by 1
**Validates: Requirements 5.2**

Property 16: Reaction round-trip
*For any* post, adding a reaction and then removing it should restore the original reaction count
**Validates: Requirements 5.3**

Property 17: Comment display completeness
*For any* comment loaded from the Feed Service, the displayed comment should include author information and timestamp
**Validates: Requirements 5.4**

Property 18: Repost count increment
*For any* post, creating a repost should increase the repost count by 1
**Validates: Requirements 5.5**

### Chat Properties

Property 19: Message retrieval completeness
*For any* chat ID, requesting messages should return all messages associated with that chat
**Validates: Requirements 6.1**

Property 20: Message persistence
*For any* valid message content and chat ID, sending a message should result in the message being persisted and retrievable
**Validates: Requirements 6.2**

Property 21: Message display
*For any* new message in a chat, the message should appear in the UI either in real-time or after refresh
**Validates: Requirements 6.3**

Property 22: Chat creation returns ID
*For any* valid set of participant IDs, creating a chat should return a Success resource with a chat ID
**Validates: Requirements 6.4**

Property 23: Message chronological ordering
*For any* chat, loading messages should return them sorted by timestamp in ascending order
**Validates: Requirements 6.5**


### Notification Properties

Property 24: Notification retrieval by user
*For any* user ID, requesting notifications should return all notifications belonging to that user
**Validates: Requirements 7.1**

Property 25: Notification status update
*For any* notification, marking it as read should update its isRead status to true
**Validates: Requirements 7.2**

Property 26: Notification badge display
*For any* new unread notification, the UI should display a badge or indicator
**Validates: Requirements 7.3**

Property 27: Notification display completeness
*For any* notification loaded from the Notification Service, the displayed notification should include type, message, and timestamp
**Validates: Requirements 7.5**

### Portfolio Properties

Property 28: Portfolio retrieval completeness
*For any* user with a portfolio, requesting the portfolio should return all illustrations and categories
**Validates: Requirements 8.1**

Property 29: Illustration persistence
*For any* valid illustration data, uploading an illustration should result in it being persisted and retrievable
**Validates: Requirements 8.2**

Property 30: Illustration deletion removes from portfolio
*For any* illustration owned by the user, deleting it should result in it no longer appearing in the portfolio
**Validates: Requirements 8.3**

Property 31: Illustration metadata update
*For any* illustration, updating its details should change the stored metadata to match the new values
**Validates: Requirements 8.4**

Property 32: Portfolio category organization
*For any* portfolio with illustrations, displaying the portfolio should group illustrations by their category
**Validates: Requirements 8.5**

### Project Properties

Property 33: Project search returns matches
*For any* search query, the Project Service should return only projects that match the search criteria
**Validates: Requirements 9.1**

Property 34: Project detail completeness
*For any* project ID, requesting project details should return complete information including requirements
**Validates: Requirements 9.2**

Property 35: Application creation
*For any* valid application data and project ID, applying to a project should create a postulación associated with that project
**Validates: Requirements 9.3**

Property 36: Application retrieval by user
*For any* user, requesting their applications should return all postulaciones belonging to that user
**Validates: Requirements 9.4**

Property 37: Project creation returns ID
*For any* valid project data, creating a project should return a Success resource with a project ID
**Validates: Requirements 9.5**


### Error Handling Properties

Property 38: Network error messages
*For any* HTTP request that fails with a network error, the system should return an Error resource with a user-friendly message
**Validates: Requirements 10.1**

Property 39: Client error parsing
*For any* 4xx HTTP response, the system should parse the error response and display a specific error message
**Validates: Requirements 10.2**

Property 40: Server error messages
*For any* 5xx HTTP response, the system should return an Error resource with a generic server error message
**Validates: Requirements 10.3**

Property 41: Timeout handling
*For any* HTTP request that times out, the system should notify the user and provide a retry option
**Validates: Requirements 10.4**

### Subscription Properties

Property 42: Subscription plan display completeness
*For any* subscription plan, displaying it should include features and pricing information
**Validates: Requirements 12.1**

Property 43: Subscription updates permissions
*For any* user subscribing to a plan, the subscription should update the user's permissions to match the plan
**Validates: Requirements 12.2**

Property 44: Expired subscription restricts access
*For any* user with an expired subscription, attempting to access premium features should be denied
**Validates: Requirements 12.3**

Property 45: Subscription status UI reflection
*For any* subscription status change, the UI should reflect the updated status
**Validates: Requirements 12.4**

Property 46: Profile displays subscription tier
*For any* user profile, loading it should display the current subscription tier
**Validates: Requirements 12.5**

### Caching Properties

Property 47: Data caching
*For any* data fetched from the server, the data should be cached and retrievable without a new request
**Validates: Requirements 13.1**

Property 48: Fresh cache usage
*For any* cached data that is fresh (not stale), requesting the data should return the cached version without a server request
**Validates: Requirements 13.2**

Property 49: Stale cache refresh
*For any* cached data that is stale, requesting the data should trigger a server request to refresh the cache
**Validates: Requirements 13.3**

Property 50: Image caching
*For any* image loaded from a URL, the image should be cached to avoid redundant downloads
**Validates: Requirements 13.4**

Property 51: Offline cached data display
*For any* cached data, when the network is unavailable, the data should be displayed with an offline indicator
**Validates: Requirements 13.5**


## Error Handling

### Error Categories

#### Network Errors
- **Timeout**: Request exceeds configured timeout (default: 30 seconds)
- **Connection Failure**: Unable to reach server
- **No Internet**: Device has no network connectivity

**Handling Strategy**:
- Display user-friendly message: "Unable to connect. Please check your internet connection."
- Provide retry button
- Log error details for debugging

#### HTTP Client Errors (4xx)
- **400 Bad Request**: Invalid request data
- **401 Unauthorized**: Invalid or expired token
- **403 Forbidden**: Insufficient permissions
- **404 Not Found**: Resource doesn't exist
- **409 Conflict**: Duplicate resource (e.g., username already exists)

**Handling Strategy**:
- Parse error response body for specific message
- Display server-provided error message to user
- For 401: Clear token, redirect to login
- For 403: Display "You don't have permission to perform this action"

#### HTTP Server Errors (5xx)
- **500 Internal Server Error**: Server-side error
- **502 Bad Gateway**: Gateway error
- **503 Service Unavailable**: Service temporarily down

**Handling Strategy**:
- Display generic message: "Something went wrong on our end. Please try again later."
- Provide retry button
- Log error for monitoring

#### Parsing Errors
- **JSON Decode Error**: Invalid JSON response
- **DTO Mapping Error**: Response doesn't match expected structure

**Handling Strategy**:
- Display: "Unable to process server response"
- Log full response for debugging
- Fallback to cached data if available

### Error Response Structure

Backend services return errors in this format:
```json
{
  "error": "Error message",
  "message": "Detailed error description",
  "status": 400
}
```

The mobile app should extract the `message` or `error` field for display.


## Testing Strategy

### Dual Testing Approach

This project will use both unit testing and property-based testing to ensure comprehensive coverage:

**Unit Tests**: Verify specific examples, edge cases, and integration points
**Property Tests**: Verify universal properties that should hold across all inputs

Together they provide complete coverage: unit tests catch concrete bugs, property tests verify general correctness.

### Property-Based Testing

**Library**: We will use the `test` package with custom property testing utilities for Dart/Flutter.

**Configuration**: Each property-based test will run a minimum of 100 iterations to ensure thorough coverage.

**Test Tagging**: Each property-based test MUST be tagged with a comment explicitly referencing the correctness property from this design document using this format:

```dart
// Feature: backend-integration, Property 1: Header inclusion
test('HTTP requests include required headers', () {
  // Property test implementation
});
```

**Property Test Structure**:
1. Generate random valid inputs
2. Execute the operation
3. Assert the property holds
4. Repeat for configured iterations

**Example Property Test**:
```dart
// Feature: backend-integration, Property 15: Reaction count increment
test('adding reaction increments count by 1', () {
  for (int i = 0; i < 100; i++) {
    // Generate random post
    final post = generateRandomPost();
    final initialCount = post.reactionCount;
    
    // Add reaction
    final result = await feedService.addReaction(post.id, randomReactionType());
    
    // Verify count increased by 1
    final updatedPost = await feedService.getPost(post.id);
    expect(updatedPost.reactionCount, equals(initialCount + 1));
  }
});
```

### Unit Testing

**Focus Areas**:
- DTO parsing from JSON
- Entity creation from DTOs
- Error response handling
- Token storage and retrieval
- HTTP client configuration
- Socket.IO connection setup

**Example Unit Test**:
```dart
test('AuthenticatedUserDto parses from JSON correctly', () {
  final json = {
    'id': 1,
    'username': 'testuser',
    'token': 'jwt.token.here',
    'role': 'ILUSTRADOR'
  };
  
  final dto = AuthenticatedUserDto.fromJson(json);
  
  expect(dto.id, equals(1));
  expect(dto.username, equals('testuser'));
  expect(dto.token, equals('jwt.token.here'));
  expect(dto.role, equals('ILUSTRADOR'));
});
```

### Integration Testing

**Scope**: Test complete flows from UI to backend
- Login flow: Enter credentials → Authenticate → Store token → Navigate to home
- Post creation flow: Create post → Upload media → Submit → Verify in feed
- Chat flow: Open chat → Send message → Verify message appears

**Tools**: Flutter integration test framework with mock backend responses

### Test Coverage Goals

- **Unit Tests**: 80% code coverage minimum
- **Property Tests**: All 51 correctness properties implemented
- **Integration Tests**: All critical user flows covered

