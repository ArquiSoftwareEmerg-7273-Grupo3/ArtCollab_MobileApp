# Requirements Document - Complete Features

## Introduction

Este documento define los requisitos para completar todas las funcionalidades restantes de ArtCollab Mobile App, manteniendo el diseño elegante y las buenas prácticas ya establecidas. El objetivo es proporcionar una experiencia completa y profesional para ambos roles (ilustradores y escritores).

## Glossary

- **Sistema**: ArtCollab Mobile App
- **Usuario**: Persona que utiliza la aplicación (ilustrador o escritor)
- **Ilustrador**: Usuario con rol de ilustrador que puede crear portafolios y postularse a empleos
- **Escritor**: Usuario con rol de escritor que puede crear empleos y contratar ilustradores
- **Empleo**: Proyecto publicado por un escritor para contratar ilustradores
- **Portafolio**: Colección de trabajos de un ilustrador
- **Perfil**: Información personal y profesional de un usuario
- **Seguidor**: Usuario que sigue a otro usuario
- **Feed**: Lista de publicaciones sociales
- **Backend**: Servidor que proporciona los servicios REST

## Requirements

### Requirement 1: Crear Empleo (Proyecto)

**User Story:** Como escritor, quiero crear empleos con toda la información necesaria, para contratar ilustradores que se ajusten a mis necesidades.

#### Acceptance Criteria

1. WHEN un escritor accede al formulario de crear empleo, THEN el Sistema SHALL mostrar todos los campos necesarios con diseño elegante
2. WHEN un escritor sube imágenes de referencia, THEN el Sistema SHALL permitir seleccionar múltiples imágenes y subirlas al Backend
3. WHEN un escritor completa el formulario con datos válidos, THEN el Sistema SHALL crear el empleo en el Backend y navegar a la vista de detalle
4. WHEN un escritor intenta crear un empleo con datos inválidos, THEN el Sistema SHALL mostrar mensajes de validación específicos
5. WHEN un empleo es creado exitosamente, THEN el Sistema SHALL mostrar un mensaje de confirmación y actualizar la lista de empleos

### Requirement 2: Gestión de Mis Empleos (Escritor)

**User Story:** Como escritor, quiero gestionar mis empleos publicados, para controlar el proceso de contratación y ver postulaciones.

#### Acceptance Criteria

1. WHEN un escritor accede a "Mis Empleos", THEN el Sistema SHALL mostrar todos sus empleos con su estado actual
2. WHEN un escritor selecciona un empleo, THEN el Sistema SHALL mostrar el detalle completo con lista de postulaciones
3. WHEN un escritor cierra un empleo, THEN el Sistema SHALL actualizar el estado en el Backend y dejar de aceptar postulaciones
4. WHEN un escritor finaliza un empleo, THEN el Sistema SHALL marcar el empleo como completado
5. WHEN un escritor edita un empleo abierto, THEN el Sistema SHALL permitir modificar la información y actualizar en el Backend

### Requirement 3: Gestión de Postulaciones (Escritor)

**User Story:** Como escritor, quiero revisar y gestionar las postulaciones a mis empleos, para seleccionar al mejor ilustrador.

#### Acceptance Criteria

1. WHEN un escritor ve las postulaciones de un empleo, THEN el Sistema SHALL mostrar todos los postulantes con su información relevante
2. WHEN un escritor selecciona un postulante, THEN el Sistema SHALL mostrar el perfil completo y portafolio del ilustrador
3. WHEN un escritor aprueba una postulación, THEN el Sistema SHALL actualizar el estado en el Backend y notificar al ilustrador
4. WHEN un escritor rechaza una postulación, THEN el Sistema SHALL permitir agregar un motivo opcional
5. WHEN una postulación es aprobada, THEN el Sistema SHALL iniciar automáticamente un chat entre escritor e ilustrador

### Requirement 4: Edición de Perfil

**User Story:** Como usuario, quiero editar mi información de perfil, para mantener mis datos actualizados y presentarme profesionalmente.

#### Acceptance Criteria

1. WHEN un usuario accede a la edición de perfil, THEN el Sistema SHALL mostrar un formulario con todos los campos editables pre-poblados con los datos actuales
2. WHEN un usuario modifica su foto de perfil, THEN el Sistema SHALL permitir seleccionar una imagen desde la galería y subirla al Backend
3. WHEN un usuario guarda cambios válidos, THEN el Sistema SHALL actualizar los datos en el Backend y mostrar un mensaje de confirmación
4. WHEN un usuario intenta guardar datos inválidos, THEN el Sistema SHALL mostrar mensajes de validación específicos para cada campo
5. WHERE el usuario es un Ilustrador, THEN el Sistema SHALL permitir editar campos específicos como especialidades y portafolio destacado

### Requirement 5: Búsqueda de Usuarios

**User Story:** Como usuario, quiero buscar otros usuarios por nombre, para encontrar y conectar con ilustradores o escritores específicos.

#### Acceptance Criteria

1. WHEN un usuario ingresa texto en el campo de búsqueda, THEN el Sistema SHALL mostrar resultados filtrados en tiempo real
2. WHEN un usuario selecciona un resultado de búsqueda, THEN el Sistema SHALL navegar al perfil del usuario seleccionado
3. WHEN no hay resultados para una búsqueda, THEN el Sistema SHALL mostrar un mensaje informativo con sugerencias
4. WHEN la búsqueda está en progreso, THEN el Sistema SHALL mostrar un indicador de carga
5. WHEN un usuario limpia el campo de búsqueda, THEN el Sistema SHALL mostrar una lista de usuarios sugeridos o recientes

### Requirement 6: Sistema de Seguimiento

**User Story:** Como usuario, quiero seguir a otros usuarios, para ver su contenido y mantenerme actualizado con su trabajo.

#### Acceptance Criteria

1. WHEN un usuario presiona el botón de seguir en un perfil, THEN el Sistema SHALL crear la relación de seguimiento en el Backend
2. WHEN un usuario presiona el botón de dejar de seguir, THEN el Sistema SHALL eliminar la relación de seguimiento del Backend
3. WHEN un usuario ve un perfil que ya sigue, THEN el Sistema SHALL mostrar el botón "Siguiendo" en lugar de "Seguir"
4. WHEN un usuario accede a su lista de seguidores, THEN el Sistema SHALL mostrar todos los usuarios que lo siguen
5. WHEN un usuario accede a su lista de seguidos, THEN el Sistema SHALL mostrar todos los usuarios que sigue

### Requirement 7: Perfil de Otros Usuarios

**User Story:** Como usuario, quiero ver los perfiles de otros usuarios, para conocer su trabajo y decidir si seguirlos o contactarlos.

#### Acceptance Criteria

1. WHEN un usuario accede al perfil de otro usuario, THEN el Sistema SHALL mostrar toda la información pública del perfil
2. WHERE el perfil es de un Ilustrador, THEN el Sistema SHALL mostrar su portafolio y trabajos destacados
3. WHERE el perfil es de un Escritor, THEN el Sistema SHALL mostrar sus empleos publicados
4. WHEN un usuario ve el perfil de otro usuario, THEN el Sistema SHALL mostrar botones para seguir y enviar mensaje
5. WHEN un usuario ve su propio perfil, THEN el Sistema SHALL mostrar el botón de editar en lugar de seguir

### Requirement 8: Búsqueda de Empleos

**User Story:** Como ilustrador, quiero buscar empleos por palabras clave y filtros, para encontrar oportunidades que se ajusten a mis habilidades.

#### Acceptance Criteria

1. WHEN un ilustrador ingresa texto en la búsqueda de empleos, THEN el Sistema SHALL filtrar los empleos por título y descripción
2. WHEN un ilustrador aplica filtros de categoría, THEN el Sistema SHALL mostrar solo empleos que coincidan con las categorías seleccionadas
3. WHEN un ilustrador aplica filtros de presupuesto, THEN el Sistema SHALL mostrar solo empleos dentro del rango de presupuesto especificado
4. WHEN un ilustrador ordena los resultados, THEN el Sistema SHALL reordenar los empleos según el criterio seleccionado (fecha, presupuesto, relevancia)
5. WHEN no hay empleos que coincidan con los filtros, THEN el Sistema SHALL mostrar un mensaje informativo

### Requirement 9: Gestión de Postulaciones (Ilustrador)

**User Story:** Como ilustrador, quiero ver y gestionar mis postulaciones a empleos, para hacer seguimiento de mis oportunidades.

#### Acceptance Criteria

1. WHEN un ilustrador accede a sus postulaciones, THEN el Sistema SHALL mostrar todas sus postulaciones con su estado actual
2. WHEN un ilustrador cancela una postulación pendiente, THEN el Sistema SHALL actualizar el estado en el Backend
3. WHEN una postulación es aprobada, THEN el Sistema SHALL mostrar un indicador visual destacado
4. WHEN una postulación es rechazada, THEN el Sistema SHALL mostrar el motivo si está disponible
5. WHEN un ilustrador filtra por estado, THEN el Sistema SHALL mostrar solo postulaciones con el estado seleccionado

### Requirement 10: Gestión de Ilustraciones en Portafolio

**User Story:** Como ilustrador, quiero agregar, editar y eliminar ilustraciones en mi portafolio, para mantener mi trabajo actualizado.

#### Acceptance Criteria

1. WHEN un ilustrador agrega una ilustración, THEN el Sistema SHALL permitir subir múltiples imágenes y agregar título y descripción
2. WHEN un ilustrador edita una ilustración, THEN el Sistema SHALL actualizar los datos en el Backend
3. WHEN un ilustrador elimina una ilustración, THEN el Sistema SHALL solicitar confirmación antes de eliminarla del Backend
4. WHEN un ilustrador publica una ilustración, THEN el Sistema SHALL cambiar su estado a publicada y hacerla visible en el feed
5. WHEN un ilustrador organiza sus ilustraciones, THEN el Sistema SHALL permitir cambiar el orden de visualización

### Requirement 11: Página de Suscripciones Mejorada

**User Story:** Como usuario, quiero ver y gestionar mi suscripción, para acceder a funcionalidades premium de la plataforma.

#### Acceptance Criteria

1. WHEN un usuario accede a suscripciones, THEN el Sistema SHALL mostrar todos los planes disponibles con diseño elegante
2. WHEN un usuario selecciona un plan, THEN el Sistema SHALL mostrar los detalles completos y el botón de suscripción
3. WHERE el usuario tiene una suscripción activa, THEN el Sistema SHALL mostrar el plan actual con fecha de renovación
4. WHEN un usuario cancela su suscripción, THEN el Sistema SHALL solicitar confirmación y procesar la cancelación
5. WHEN un usuario mejora su plan, THEN el Sistema SHALL calcular el prorrateo y procesar el cambio

### Requirement 12: Sistema de Chat Alternativo

**User Story:** Como usuario, quiero comunicarme con otros usuarios de manera efectiva, para coordinar proyectos y colaboraciones.

#### Acceptance Criteria

1. WHEN se aprueba una postulación, THEN el Sistema SHALL crear automáticamente un canal de comunicación entre escritor e ilustrador
2. WHERE se usa Firebase, THEN el Sistema SHALL sincronizar mensajes en tiempo real sin depender del servicio de chat del Backend
3. WHERE se usa Socket.IO, THEN el Sistema SHALL mantener una conexión persistente para mensajería instantánea
4. WHEN un usuario envía un mensaje, THEN el Sistema SHALL entregar el mensaje inmediatamente al destinatario si está en línea
5. WHEN un usuario recibe un mensaje, THEN el Sistema SHALL mostrar una notificación push si la app está en segundo plano

### Requirement 13: Notificaciones Mejoradas

**User Story:** Como usuario, quiero recibir notificaciones relevantes, para mantenerme informado de actividades importantes.

#### Acceptance Criteria

1. WHEN ocurre una acción relevante, THEN el Sistema SHALL crear una notificación en el Backend
2. WHEN un usuario abre la app, THEN el Sistema SHALL sincronizar las notificaciones no leídas
3. WHEN un usuario toca una notificación, THEN el Sistema SHALL navegar al contenido relacionado
4. WHEN un usuario marca todas como leídas, THEN el Sistema SHALL actualizar el estado de todas las notificaciones
5. WHEN hay notificaciones no leídas, THEN el Sistema SHALL mostrar un badge en el icono de notificaciones

