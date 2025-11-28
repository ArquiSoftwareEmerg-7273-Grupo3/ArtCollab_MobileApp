# Requirements Document

## Introduction

Este documento define los requisitos para integrar la aplicación móvil ArtCollab con los microservicios backend existentes. Actualmente, la aplicación móvil Flutter funciona con datos JSON estáticos. El objetivo es reemplazar esta implementación con llamadas HTTP reales a los microservicios (auth-service, feed-service, chat-service, notification-service, portfolio-service, project-service) a través del API Gateway, implementando autenticación JWT, manejo de errores robusto, y una arquitectura limpia que separe las capas de datos, dominio y presentación.

## Glossary

- **Mobile App**: La aplicación móvil Flutter (ArtCollab_MobileApp) que conecta ilustradores y escritores
- **API Gateway**: El punto de entrada único para todos los microservicios backend (puerto 8080)
- **Auth Service**: Microservicio de autenticación y gestión de usuarios
- **Feed Service**: Microservicio para posts, comentarios, reacciones y reposts
- **Chat Service**: Microservicio para mensajería entre usuarios
- **Notification Service**: Microservicio para notificaciones push y en tiempo real
- **Portfolio Service**: Microservicio para gestión de portafolios e ilustraciones
- **Project Service**: Microservicio para gestión de proyectos (empleos) y postulaciones
- **JWT Token**: Token de autenticación JSON Web Token usado para autorizar peticiones
- **HTTP Client**: Cliente HTTP (package http de Dart) para realizar peticiones REST
- **Data Layer**: Capa de datos que contiene servicios remotos, DTOs y repositorios
- **Domain Layer**: Capa de dominio que contiene entidades y lógica de negocio
- **Presentation Layer**: Capa de presentación que contiene BLoCs, Cubits y páginas UI
- **DTO**: Data Transfer Object - objeto para transferir datos entre capas
- **Repository**: Patrón repositorio que abstrae el acceso a datos
- **BLoC**: Business Logic Component - patrón de gestión de estado en Flutter
- **Resource**: Tipo genérico para encapsular resultados (Success/Error)
- **Socket.IO**: Biblioteca para comunicación en tiempo real mediante WebSockets
- **WebSocket**: Protocolo de comunicación bidireccional para actualizaciones en tiempo real

## Requirements

### Requirement 1

**User Story:** Como desarrollador, quiero revisar exhaustivamente el código de todos los microservicios backend, para que tenga el contexto completo de endpoints, modelos de datos, y contratos de API antes de implementar la integración.

#### Acceptance Criteria

1. WHEN reviewing backend services THEN the system SHALL analyze all controller endpoints in auth-service, feed-service, chat-service, notification-service, portfolio-service, and project-service
2. WHEN analyzing endpoints THEN the system SHALL document all URL paths, HTTP methods, request bodies, and response structures
3. WHEN examining data models THEN the system SHALL identify all entity classes, DTOs, and their field types
4. WHEN reviewing API Gateway configuration THEN the system SHALL verify all route mappings and service URLs
5. WHEN documenting backend contracts THEN the system SHALL create a comprehensive reference of all available APIs

### Requirement 2

**User Story:** Como desarrollador, quiero configurar la infraestructura base de comunicación HTTP y WebSocket, para que la aplicación móvil pueda comunicarse con el API Gateway y recibir actualizaciones en tiempo real.

#### Acceptance Criteria

1. WHEN the Mobile App initializes THEN the system SHALL configure the HTTP client with base URL pointing to the API Gateway
2. WHEN making HTTP requests THEN the system SHALL include proper headers (Content-Type, Authorization)
3. WHEN a JWT Token exists THEN the system SHALL automatically include it in the Authorization header for authenticated requests
4. WHEN network errors occur THEN the system SHALL handle timeouts and connection failures gracefully
5. WHEN HTTP responses are received THEN the system SHALL parse JSON responses into DTOs correctly
6. WHEN connecting to Feed Service THEN the system SHALL establish Socket.IO connection for real-time updates

### Requirement 3

**User Story:** Como usuario, quiero autenticarme en la aplicación usando mis credenciales, para que pueda acceder a las funcionalidades protegidas del sistema.

#### Acceptance Criteria

1. WHEN a user submits valid credentials THEN the Auth Service SHALL authenticate the user and return a JWT Token
2. WHEN authentication succeeds THEN the Mobile App SHALL store the JWT Token securely for subsequent requests
3. WHEN authentication fails THEN the Mobile App SHALL display appropriate error messages to the user
4. WHEN a user registers a new account THEN the Auth Service SHALL create the user and return confirmation
5. WHEN the JWT Token expires THEN the Mobile App SHALL prompt the user to re-authenticate

### Requirement 4

**User Story:** Como usuario autenticado, quiero ver el feed de publicaciones con actualizaciones en tiempo real, para que pueda explorar contenido de ilustradores y escritores y recibir nuevas publicaciones instantáneamente.

#### Acceptance Criteria

1. WHEN a user opens the feed THEN the Feed Service SHALL return paginated posts with author information
2. WHEN posts are loaded THEN the Mobile App SHALL display posts with content, images, tags, and metadata
3. WHEN a user scrolls to the bottom THEN the Mobile App SHALL load the next page of posts automatically
4. WHEN a user creates a new post THEN the Feed Service SHALL persist the post and return the created post ID
5. WHEN a user deletes their post THEN the Feed Service SHALL remove the post and update the feed
6. WHEN the Socket.IO connection is established THEN the Mobile App SHALL listen for real-time post events
7. WHEN a new post is created by any user THEN the Feed Service SHALL emit the post event via Socket.IO
8. WHEN real-time events are received THEN the Mobile App SHALL update the feed UI without requiring manual refresh

### Requirement 5

**User Story:** Como usuario autenticado, quiero interactuar con publicaciones mediante comentarios y reacciones, para que pueda participar en la comunidad.

#### Acceptance Criteria

1. WHEN a user adds a comment to a post THEN the Feed Service SHALL persist the comment and associate it with the post
2. WHEN a user reacts to a post THEN the Feed Service SHALL record the reaction and update the reaction count
3. WHEN a user removes a reaction THEN the Feed Service SHALL delete the reaction and decrement the count
4. WHEN comments are loaded THEN the Mobile App SHALL display comments with author information and timestamps
5. WHEN a user reposts content THEN the Feed Service SHALL create a repost reference and update the repost count

### Requirement 6

**User Story:** Como usuario autenticado, quiero enviar y recibir mensajes de chat, para que pueda comunicarme directamente con otros usuarios.

#### Acceptance Criteria

1. WHEN a user opens a chat THEN the Chat Service SHALL return all messages for that conversation
2. WHEN a user sends a message THEN the Chat Service SHALL persist the message and associate it with the chat
3. WHEN a new message arrives THEN the Mobile App SHALL display the message in real-time or on refresh
4. WHEN a user creates a new chat THEN the Chat Service SHALL create the chat room and return the chat ID
5. WHEN loading chat history THEN the Mobile App SHALL display messages in chronological order with sender information

### Requirement 7

**User Story:** Como usuario autenticado, quiero ver y gestionar notificaciones, para que pueda estar informado de actividades relevantes.

#### Acceptance Criteria

1. WHEN a user opens notifications THEN the Notification Service SHALL return all notifications for that user
2. WHEN a notification is marked as read THEN the Notification Service SHALL update the notification status
3. WHEN new notifications arrive THEN the Mobile App SHALL display a badge or indicator
4. WHEN a user taps a notification THEN the Mobile App SHALL navigate to the relevant content
5. WHEN notifications are loaded THEN the Mobile App SHALL display notifications with type, message, and timestamp

### Requirement 8

**User Story:** Como ilustrador o escritor, quiero gestionar mi portafolio, para que pueda mostrar mi trabajo a la comunidad.

#### Acceptance Criteria

1. WHEN a user views a portfolio THEN the Portfolio Service SHALL return all illustrations and categories for that user
2. WHEN a user uploads an illustration THEN the Portfolio Service SHALL persist the illustration with metadata
3. WHEN a user deletes an illustration THEN the Portfolio Service SHALL remove the illustration from the portfolio
4. WHEN a user updates illustration details THEN the Portfolio Service SHALL update the illustration metadata
5. WHEN portfolios are displayed THEN the Mobile App SHALL show illustrations organized by categories

### Requirement 9

**User Story:** Como usuario autenticado, quiero buscar y postular a proyectos, para que pueda encontrar oportunidades de colaboración.

#### Acceptance Criteria

1. WHEN a user searches for projects THEN the Project Service SHALL return matching projects with details
2. WHEN a user views project details THEN the Project Service SHALL return complete project information including requirements
3. WHEN a user applies to a project THEN the Project Service SHALL create a postulación and associate it with the project
4. WHEN a user views their applications THEN the Project Service SHALL return all postulaciones for that user
5. WHEN a project owner creates a project THEN the Project Service SHALL persist the project and return the project ID

### Requirement 10

**User Story:** Como desarrollador, quiero implementar manejo de errores robusto, para que la aplicación móvil maneje fallos de red y errores del servidor apropiadamente.

#### Acceptance Criteria

1. WHEN HTTP requests fail with network errors THEN the Mobile App SHALL display user-friendly error messages
2. WHEN the server returns 4xx errors THEN the Mobile App SHALL parse error responses and display specific messages
3. WHEN the server returns 5xx errors THEN the Mobile App SHALL display generic server error messages
4. WHEN requests timeout THEN the Mobile App SHALL notify the user and allow retry
5. WHEN authentication fails with 401 THEN the Mobile App SHALL clear stored tokens and redirect to login

### Requirement 11

**User Story:** Como desarrollador, quiero implementar una arquitectura limpia con separación de capas, para que el código sea mantenible y testeable.

#### Acceptance Criteria

1. WHEN implementing features THEN the system SHALL separate Data Layer, Domain Layer, and Presentation Layer
2. WHEN creating remote services THEN the Data Layer SHALL contain HTTP clients and API communication logic
3. WHEN defining business entities THEN the Domain Layer SHALL contain entity models independent of data sources
4. WHEN implementing UI logic THEN the Presentation Layer SHALL use BLoCs or Cubits for state management
5. WHEN converting between layers THEN the system SHALL use DTOs to transform API responses to domain entities

### Requirement 12

**User Story:** Como usuario, quiero que la aplicación gestione planes de suscripción, para que pueda acceder a funcionalidades premium.

#### Acceptance Criteria

1. WHEN a user views subscription plans THEN the Mobile App SHALL display available plans with features and pricing
2. WHEN a user subscribes to a plan THEN the system SHALL process the subscription and update user permissions
3. WHEN a user's subscription expires THEN the Mobile App SHALL restrict access to premium features
4. WHEN subscription status changes THEN the Mobile App SHALL reflect the updated status in the UI
5. WHEN loading user profile THEN the Mobile App SHALL display current subscription tier

### Requirement 13

**User Story:** Como desarrollador, quiero implementar caching y optimización de peticiones, para que la aplicación móvil tenga mejor rendimiento y consuma menos datos.

#### Acceptance Criteria

1. WHEN data is fetched from the server THEN the Mobile App SHALL cache responses for subsequent access
2. WHEN cached data exists and is fresh THEN the Mobile App SHALL use cached data instead of making new requests
3. WHEN cached data is stale THEN the Mobile App SHALL refresh data from the server
4. WHEN images are loaded THEN the Mobile App SHALL cache images to avoid redundant downloads
5. WHEN network is unavailable THEN the Mobile App SHALL display cached data with appropriate indicators
