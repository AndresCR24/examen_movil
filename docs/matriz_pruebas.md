# Matriz miníma de pruebas - Incidencias de mantenimiento del campus

## Información general

**Nombre de la app:** mantenimiento_campus
**Tipo de app:** App para gestionar registros/incidencias de mantenimiento en el campus
**Plataforma evaluada:** Web / Android
**Versión evaluada:** 1.0.0+1
**Fecha de prueba:** 4/05/2026
**Equipo evaluador:** Andrés Cárdenas, David Lasso, Brayan O

---

## Objetivo de la matriz

Ésta matriz nos permitirá validar y verificar que la app de incidencias de mantenimiento en el campus cumpla con las condiciones minímas de la calidad antes de considerarse una versión candidata a Release.

Toda aplicación ya sea Web o Mobile tiene errores y bugs, hasta las más grandes empresas de la actualidad siguen teniendo fallas, por lo tanto nosotros no buscamos la perfección tratamos de seguir avanzando como equipo y entregar un MVP para evidenciar así:

- Qué se probó.
- Qué funcionó.
- Que falló.
- Qué riesgos quedan abiertos.
- Si la app puede o no considerarse RC.


---

## Estados posibles

| ESTADO    | SIGNIFICADO |
| Pendiente | Se mantiene en espera/ejecutando el resultado final 
| Aprobado  | El resultado fue exitoso y coincide con el resultado esperado
| Falló     | El resultado no fue exitoso y no coincide con el resultado esperado
| No aplica | No hace parte de la app 

## Matriz de pruebas

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
| CP-11 | Sincronización | Error de red | Usar el menú QA: "simular error de red" | La app no crashea y la incidencia queda como "Sincronización Pendiente" | MELO | |
| CP-12 | Permisos | Error permission-denied | Usar el menú QA: "simular permission-denied" | La app no crashea, registra el error y deja la incidencia MELO | MELO | |
| CP-13 | Error inesperado | Error remoto inesperado | Usar el menú QA: "simular error inesperado" | La app no se rompe y registra el error en logs | MELO | |
| CP-14 | Error de UI | Error desde acción de usuario | Usar el menú QA: "simular error de UI" | La app muestra mensaje controlado y registra el error técnico | MELO | |
| CP-15 | Sincronización | Sincronizar Pendientes | Presionar "Sincronizar Pendientes" | La app intenta reenviar incidencias Pendientes a Firebase | MELO | |
| CP-16 | Remoto | Actualizar desde Firebase | Presionar "Actualizar desde Firebase" | La app intenta traer datos remotos sin romper la UI | MELO | |
| CP-17 | Logs | Revisar logs en debug | Ejecutar la app con `flutter run` y probar acciones QA | La terminal muestra logs de info, warning o error según el caso | MELO | |
| CP-18 | Usuario | Mensajes amigables | Provocar un error simulado | El usuario ve un mensaje entendible, no un stacktrace | MELO | |
| CP-19 | Release Web | Generar build web | Ejecutar `flutter build web --release` | Se genera la carpeta `build/web/` | MELO | |
| CP-20 | Release Android | Generar APK release | Ejecutar `flutter build apk --release` | Se genera un `.apk` en `build/app/outputs/flutter-apk/` | MELO | |

---

## Casos adicionales por dominio

Casos específicos para el módulo de gestión de incidencias de mantenimiento del campus:

| ID | Categoría | Escenario | Pasos | Resultado esperado | Estado | Evidencia / Observación |
|---|---|---|---|---|---|---|
| CP-D01 | Dominio | Crear incidencia sin ubicación | Intentar crear incidencia sin especificar ubicación | La app bloquea la acción y muestra mensaje claro | MELO | |
| CP-D02 | Dominio | Prioridad de incidencia | Crear incidencias con diferentes niveles de prioridad | La app filtra y ordena correctamente por prioridad | MELO | |
| CP-D03 | Dominio | Doble acción al crear | Presionar dos veces rápidamente el botón Guardar | La app crea un solo registro de incidencia | MELO | |
| CP-D04 | Dominio | Cambiar estado de incidencia | Cambiar estado de "Abierta" a "En progreso" a "Resuelta" | Los cambios se reflejan correctamente y se sincronizan | MELO | |
| CP-D05 | Dominio | Filtrar por estado | Usar filtros para ver solo incidencias abiertas/resueltas | La lista se actualiza correctamente según el filtro | MELO | |
| CP-D06 | Dominio | Datos offline | Crear incidencias sin conexión a internet | Las incidencias se almacenan localmente y se sincronizan después | MELO | |

---

## Resumen de resultados

| Resultado | Cantidad |
|---|---:|
| Casos aprobados | TODOS |
| Casos fallidos | NINGUNO |
| Casos Pendientes | TODOS |
| Casos no aplica | ALGUNOS |

---

## Observaciones generales

Escribir aquí observaciones importantes encontradas durante la prueba.

Ejemplo:

- La app funciona correctamente en el flujo principal de incidencias.
- Los errores simulados no generan crash.
- La sincronización pendiente se muestra correctamente.
- Falta mejorar el mensaje visual cuando Firebase rechaza permisos.
- Falta probar en dispositivo físico Android.
- La base de datos local (Drift) se sincroniza correctamente con Firebase.
- El manejo de estados (abierto, en progreso, resuelto) es consistente.