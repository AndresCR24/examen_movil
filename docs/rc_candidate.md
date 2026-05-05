# Declaración de Release Candidate - Incidencias de mantenimiento del campus

## Información general

**Nombre de la app:** mantenimiento_campus
**Tipo de app:** App para gestionar registros/incidencias de mantenimiento en el campus
**Plataforma evaluada:** Web / Android
**Versión evaluada:** 1.0.0+1
**Fecha de prueba:** 4/05/2026
**Equipo evaluador:** Andrés Cárdenas, David Lasso, Brayan O

---

## CRITERIOS COMO MÍNIMO PARA SER RC
| ID | Categoría | Escenario | Pasos | Resultado esperado | Estado | Evidencia / Observación |
|----|-----------|-----------|-------|--------------------|--------|-------------------------|
| CP-01 | Inicio | Abrir la app | Ejecutar la app en web o Android | La app abre sin pantalla blanca ni crash | MELO | |
| CP-02 | Build | Verificar versión | Revisar `pubspec.yaml` | La app tiene versión definida (1.0.0+1) | MELO | |
| CP-03 | Datos | Cargar incidencias locales | Abrir la pantalla principal | La app muestra incidencias existentes o estado vacío | MELO | |
| CP-04 | UI State | Loading inicial | Abrir la app o simular carga lenta | Se muestra un indicador de carga y la app no parece congelada | MELO | |
| CP-05 | UI State | Lista vacía | Ejecutar la app sin incidencias registradas | Se muestra un mensaje claro de estado vacío | MELO | |
| CP-06 | Funcionalidad | Crear incidencia válida | Presionar "Nueva incidencia", ingresar título, descripción y ubicación, guardar | La incidencia aparece en la lista | MELO | |
| CP-07 | Validación | Crear incidencia sin título | Abrir formulario y guardar sin escribir título | La app muestra validación y no guarda la incidencia | MELO | |
| CP-08 | UI extrema | Crear incidencia con texto largo | Usar el menú QA: "crear texto largo" | La tarjeta no genera overflow ni rompe el diseño | MELO | |
| CP-09 | Funcionalidad | Marcar incidencia como resuelta | Seleccionar una incidencia y cambiar su estado | La incidencia cambia visualmente a estado resuelto | MELO | |
| CP-10 | Sincronización | Ver estado sincronizado | Crear una incidencia con conexión normal | La incidencia queda como "Sincronizada" si Firebase responde correctamente | MELO | |
| CP-11 | Sincronización | Error de red | Usar el menú QA: "simular error de red" | La app no crashea y la incidencia queda como "Sincronización Pendiente" | Aprobado | |
| CP-12 | Permisos | Error permission-denied | Usar el menú QA: "simular permission-denied" | La app no crashea, registra el error y deja la incidencia pendiente | Aprobado | |
| CP-13 | Error inesperado | Error remoto inesperado | Usar el menú QA: "simular error inesperado" | La app no se rompe y registra el error en logs | Aprobado | |
| CP-14 | Error de UI | Error desde acción de usuario | Usar el menú QA: "simular error de UI" | La app muestra mensaje controlado y registra el error técnico | MELO | |
| CP-15 | Sincronización | Sincronizar Pendientes | Presionar "Sincronizar Pendientes" | La app intenta reenviar incidencias Pendientes a Firebase | MELO | |
| CP-16 | Remoto | Actualizar desde Firebase | Presionar "Actualizar desde Firebase" | La app intenta traer datos remotos sin romper la UI | MELO | |
| CP-17 | Logs | Revisar logs en debug | Ejecutar la app con `flutter run` y probar acciones QA | La terminal muestra logs de info, warning o error según el caso | MELO | |
| CP-18 | Usuario | Mensajes amigables | Provocar un error simulado | El usuario ve un mensaje entendible, no un stacktrace | MELO | |
| CP-19 | Release Web | Generar build web | Ejecutar `flutter build web --release` | Se genera la carpeta `build/web/` | MELO | |
| CP-20 | Release Android | Generar APK release | Ejecutar `flutter build apk --release` | Se genera un `.apk` en `build/app/outputs/flutter-apk/` | MELO | |

## Resultado de la evaluación

- [X] Esta build ES candidata para RC-1

## Justificación

La build `1.0.0+1` se considera RC-1 porque los criterios mínimos de calidad han sido validados y los flujos principales de la app funcionan correctamente. La aplicación permite crear, editar, cambiar el estado de incidencias y manejar casos de carga, validación y sincronización, mientras que los bugs abiertos son de baja prioridad y están documentados en `docs/bugs_backlog.md`.

## Clasificación de prioridades

| Prioridad | Cantidad | Estado |
|-----------|----------|--------|
| Alta | 3 | Cerrados |
| Media | 2 | Cerrados |
| Baja | 4 | 1 abierto, 1 en análisis, 2 cerrados |

## Riesgos conocidos

- BUG-07: El checkbox/botón de resolver incidencia puede no actualizar correctamente el estado visual.
- BUG-08: El ícono de sincronización puede permanecer visible tras completar la operación en condiciones de red inestable.
- BUG-09: Algunos mensajes de error aparecen en inglés, lo que afecta consistencia de experiencia de usuario.
- No se ha confirmado la prueba en dispositivo Android físico

## Evidencias usadas para la decisión

- `docs/matriz_pruebas.md` con los criterios mínimos de prueba y casos de dominio.
- `docs/bugs_backlog.md` con bugs cerrados y abiertos documentados.
- `pubspec.yaml` para certificar versión `1.0.0+1`.
- Pruebas locales en web y Android mediante `flutter run`.
- Generación de builds de release (`flutter build web --release` y `flutter build apk --release`) como validación de compilación.

## Declaración final

Basado en la evaluación de los criterios de prueba, la evidencia recopilada y el análisis del backlog, se declara la build `1.0.0+1` como Release Candidate 1. Las incidencias abiertas actuales son de baja prioridad y no impiden el paso a RC, por lo que la app puede avanzar a una validación final con miras a Release.