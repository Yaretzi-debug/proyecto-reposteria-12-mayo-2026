# 📘 PLAN DE IMPLEMENTACIÓN TÉCNICA: Repostería Fresh Tarts
**Framework:** Flutter (Dart) | **Backend:** Firebase Auth + Firestore | **Plataformas:** Android, iOS, Web, Windows  
**Estado:** MVP sin analíticas ni tracking de producción | **Gestión de Estado:** Provider | **IDE:** VS Code

---

## 1. 🎯 Alcance y Enfoque Técnico
- **Objetivo:** Desarrollo de una aplicación multiplataforma para la gestión integral de una repostería (inventario, recetas, productos, pedidos y ventas).
- **Restricciones explícitas:** Exclusión total de `firebase_analytics`, `crashlytics`, `performance_monitoring` y cualquier SDK de telemetría en producción. Enfoque 100% funcional y local/emulado.
- **Arquitectura:** Separación clara por capas (Presentación → Dominio → Datos), patrón MVVM ligero con `Provider` como orquestador de estado.
- **Base de datos:** Firestore (NoSQL orientado a documentos). Se mantendrá la estructura relacional proporcionada mediante referencias explícitas y subcolecciones donde sea necesario para optimizar lecturas.

---

## 2. 🛠️ Stack Tecnológico y Entorno de Desarrollo
| Componente | Detalle |
|------------|---------|
| **SDK** | Flutter 3.x (canal estable) + Dart 3.x |
| **IDE** | VS Code con extensiones: `Flutter`, `Dart`, `Pubspec Assist`, `Error Lens`, `GitLens`, `Dart Code Metrics` |
| **Control de Versiones** | Git + flujo GitFlow (`main`, `develop`, `feature/*`, `release/*`) |
| **Backend** | Firebase Authentication (Email/Password) + Cloud Firestore |
| **Emuladores** | Firebase Emulator Suite (Auth, Firestore), Android AVD, iOS Simulator, Chrome (Web), Flutter Desktop (Windows) |
| **Diseño** | Figma (prototipado, design tokens, exportación de assets) |

---

## 3. 📁 Arquitectura de Directorios (`bin/` y Núcleo Dart)
> ⚠️ **Nota técnica:** En Flutter, el código fuente reside en `lib/`. La carpeta `bin/` se reserva oficialmente para scripts de compilación, ejecutables CLI o salidas de build. Se estructura según tu solicitud manteniendo estándares profesionales:

```
fresh_tarts_app/
├── bin/                          # Scripts de despliegue, runners y utilidades CLI
│   ├── build_android.sh
│   ├── build_ios.sh
│   ├── build_web.sh
│   ├── build_windows.ps1
│   └── firebase_emulator.sh
├── lib/                          # Código fuente Dart (núcleo de la app)
│   ├── core/                     # Constantes, rutas, temas, utilidades, validators
│   ├── data/                     # Repositorios, mappers, fuentes de datos (Firestore)
│   ├── domain/                   # Entidades, casos de uso, interfaces de repositorio
│   ├── presentation/             # Pantallas, widgets, controladores UI, providers
│   └── main.dart                 # Punto de entrada
├── android/ ios/ web/ windows/   # Carpetas nativas por plataforma
├── assets/                       # Imágenes, fuentes, iconos, mock data JSON
└── pubspec.yaml                  # Declaración de dependencias y assets
```

---

## 4. 🎨 Sistema de Diseño UI/UX y Paleta Cromática
### Principios de Diseño
- **Jerarquía visual clara:** Títulos > subtítulos > cuerpo > metadata
- **Grid de 8px:** Espaciado consistente en márgenes, padding y componentes
- **Accesibilidad:** Contraste WCAG AA, áreas táctiles ≥48dp, soporte para lectores de pantalla
- **Microinteracciones:** Feedback inmediato en botones, transiciones suaves (`FadeThrough`, `SharedAxis`)
- **Responsive:** Layouts adaptativos (`LayoutBuilder`, `MediaQuery`, `Breakpoints` para Web/Desktop)

### 🎨 Tabla de Paleta Cromática (Foreground & UI)
| Rol de Color | Código HEX | Uso Principal | Nota de Accesibilidad |
|--------------|------------|---------------|------------------------|
| `Primary` | `#D45D6E` | Botones principales, acentos de marca, estados activos | Texto blanco sobre este color cumple WCAG AA |
| `Primary Light` | `#F4E1E4` | Fondos de tarjetas, estados hover, selecciones | Usado como superficie suave |
| `Secondary` | `#F9A825` | Iconos destacados, precios, badges, CTA secundarios | Alto contraste sobre fondos neutros |
| `Accent` | `#4CAF50` | Éxito, stock disponible, confirmaciones | Verificado para legibilidad |
| `Background` | `#FAFAFA` | Fondo global de pantallas | Neutro, reduce fatiga visual |
| `Surface` | `#FFFFFF` | Tarjetas, modales, formularios, contenedores elevados | Sombra sutil `BoxShadow` |
| `Text Primary` | `#1A1A1A` | Títulos, cuerpo principal, labels críticos | Contraste > 4.5:1 sobre `Surface` |
| `Text Secondary` | `#616161` | Descripciones, timestamps, metadata | Usado en listas y detalles |
| `Error` | `#E53935` | Validaciones fallidas, stock crítico, eliminación | Icono + texto para accesibilidad |
| `Warning` | `#FF9800` | Stock bajo, fechas límite, advertencias | Combinado con `Text Secondary` para contexto |
| `Foreground Overlay` | `#000000` (α 0.6) | Backdrops, modales, carga, diálogos | Asegura legibilidad sobre contenido |

---

## 5. 🗃️ Modelo de Datos y Mapeo a Firestore
Firestore es orientado a documentos. Las entidades relacionales se mapean manteniendo referencias explícitas y desnormalizando lecturas frecuentes. Cada documento incluirá los campos de auditoría proporcionados.

| Colección Firestore | Atributos (Document Fields) | Estrategia de Indexación/Relación |
|---------------------|-----------------------------|-----------------------------------|
| `roles` | `id`, `nombre`, `descripcion`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by` | Índice simple por `is_active` + `nombre` |
| `usuarios` | `id`, `email`, `password_hash`, `nombre_completo`, `telefono`, `rol_id`, `is_active`, `fecha_ultimo_login`, `created_at`, `updated_at`, `created_by`, `updated_by` | `email` único, `rol_id` referenciado. Sin storing real de `password_hash` (Firebase Auth lo gestiona) |
| `clientes` | `id`, `nombre`, `email`, `telefono`, `direccion`, `es_empresa`, `notas`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by` | Búsqueda por `email` y `nombre` |
| `proveedores` | `id`, `nombre`, `contacto`, `email`, `telefono`, `direccion`, `notas`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by` | Filtro por `is_active` + `nombre` |
| `categorias` | `id`, `nombre`, `tipo`, `descripcion`, `color_hex`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by` | Índice por `tipo` + `is_active` |
| `unidades_medida` | `id`, `codigo`, `nombre`, `precision_decimales`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by` | Lookup estático en cache local |
| `ingredientes` | `id`, `codigo`, `nombre`, `proveedor_id`, `unidad_id`, `costo_unitario`, `stock_minimo`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by` | Referencia a `proveedores` y `unidades_medida` |
| `recetas` | `id`, `codigo`, `nombre`, `porciones`, `tiempo_preparacion_min`, `instrucciones`, `costo_total`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by` | Contiene subcolección `ingredientes_receta` |
| `receta_ingredientes` | `id`, `receta_id`, `ingrediente_id`, `cantidad`, `unidad_id`, `costo_linea`, `orden`, `created_at` | Subcolección dentro de `recetas/{id}/ingredientes` |
| `productos` | `id`, `codigo`, `nombre`, `categoria_id`, `precio_venta`, `costo_estimado`, `tiempo_preparacion_min`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by` | Índice compuesto: `categoria_id` + `is_active` |
| `inventario` | `id`, `tipo_item`, `item_id`, `unidad_id`, `cantidad`, `stock_minimo`, `ubicacion`, `ultimo_movimiento`, `created_at`, `updated_at` | `tipo_item`: `ingrediente` | `producto`. Filtro por `cantidad < stock_minimo` |
| `pedidos` | `id`, `codigo`, `cliente_id`, `fecha_pedido`, `fecha_entrega_estimada`, `estado`, `total_neto`, `notas`, `created_at`, `updated_at`, `created_by`, `updated_by` | Subcolección `items`. Estado enum: `pendiente`, `en_preparacion`, `listo`, `entregado`, `cancelado` |
| `pedido_items` | `id`, `pedido_id`, `producto_id`, `receta_id`, `nombre_item`, `cantidad`, `precio_unitario`, `total_linea`, `notas`, `created_at` | Subcolección dentro de `pedidos/{id}/items` |
| `ventas` | `id`, `codigo`, `pedido_id`, `cliente_id`, `fecha_venta`, `total_bruto`, `total_descuento`, `total_neto`, `metodo_pago`, `estado`, `created_at`, `created_by` | Referencia a `pedidos`. Métodos: `efectivo`, `tarjeta`, `transferencia`, `mixto` |

> 🔍 **Reglas de Seguridad (Firestore):** Acceso restringido por `request.auth.uid`. Campos `created_by`/`updated_by` validados contra `auth.uid`. Lecturas públicas limitadas a `is_active == true`. Escrituras solo permitidas si `rol_id` coincide con permisos definidos.

---

## 6. 📦 Dependencias (`pubspec.yaml`)
*(Versiones referenciales estables. Validar en `pub.dev` al momento de integración)*

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Core Firebase
  firebase_core: ^3.x.x
  firebase_auth: ^5.x.x
  cloud_firestore: ^5.x.x
  # Estado
  provider: ^6.x.x
  # UI & Assets
  flutter_svg: ^2.x.x
  cached_network_image: ^3.x.x
  intl: ^0.19.x
  # Utilidades
  uuid: ^4.x.x
  equatable: ^2.x.x
  flutter_secure_storage: ^9.x.x
  go_router: ^14.x.x  # Enrutamiento declarativo
  # Dev & Testing
  flutter_test:
    sdk: flutter
  mockito: ^5.x.x
  build_runner: ^2.x.x
  flutter_lints: ^4.x.x
```
> 🚫 **Excluidos intencionalmente:** `firebase_analytics`, `firebase_crashlytics`, `firebase_performance`, `sentry_flutter`, `mixpanel`, `segment`. Cumplimiento estricto de "sin analíticas/producción".

---

## 7. 📊 Arquitectura de Estado con Provider
- **Estructura de Providers:**
  - `AuthProvider`: Gestiona sesión, `User` actual, rol, estado de autenticación, errores de login/registro.
  - `CatalogProvider`: Productos, categorías, filtros, búsqueda en tiempo real.
  - `InventoryProvider`: Stock, alertas de mínimo, movimientos, proveedores.
  - `OrderProvider`: Carrito local, creación de pedidos, estados, cálculo de totales.
  - `SalesProvider`: Historial de ventas, métodos de pago, reportes simples.
  - `UIProvider`: Tema, idioma, navegación global, snackbars, loaders.
- **Patrón de consumo:** `MultiProvider` en `main.dart`. Uso de `Consumer`, `Selector`, `context.watch` para minimizar rebuilds.
- **Separación de responsabilidades:** Providers solo contienen lógica de negocio y llamadas a repositorios. La UI consume estado, no ejecuta queries directas.

---

## 8. 🔐 Flujo de Autenticación y Control de Acceso
1. **Registro:** Email + contraseña (mínimo 8 caracteres, 1 mayúscula, 1 número, 1 símbolo). Validación previa con `go_router` + `RegExp`.
2. **Login:** `signInWithEmailAndPassword`. Al éxito, se guarda `fecha_ultimo_login` en `usuarios`.
3. **Sesión persistente:** Firebase maneja tokens automáticamente. `flutter_secure_storage` para preferencias locales (tema, último rol activo).
4. **Recuperación:** `sendPasswordResetEmail`. Flujo con deep link o página interna.
5. **Autorización por Rol:** Tras login, se consulta `usuarios/{uid} → rol_id → roles/{id}`. Se cachea en `AuthProvider`. Rutas protegidas evalúan permisos antes de renderizar.
6. **Logout:** `signOut()`, limpieza de providers, redirección a `/login`.

---

## 9. 📅 Procedimiento de Implementación Paso a Paso

### 🟢 Fase 1: Configuración del Entorno y Estructura Base
1. Instalar Flutter SDK, configurar VS Code y extensiones.
2. Crear proyecto: `flutter create --platforms=android,ios,web,windows fresh_tarts_app`
3. Configurar estructura de carpetas (`lib/`, `bin/`, `assets/`).
4. Integrar Firebase: `flutterfire configure`, descargar configs nativas, inicializar en `main.dart`.
5. Configurar `go_router`, temas globales y `pubspec.yaml`.
6. Validar compilación limpia en las 4 plataformas.

### 🟡 Fase 2: UI/UX y Navegación Esqueleto
1. Implementar `ThemeData` con paleta definida, tipografía y espaciados.
2. Crear pantallas vacías con placeholders: `LoginScreen`, `RegisterScreen`, `Dashboard`, `CatalogScreen`, `InventoryScreen`, `OrdersScreen`, `SalesScreen`, `SettingsScreen`.
3. Configurar rutas públicas/privadas y transiciones.
4. Validar responsive en Web/Desktop y adaptabilidad móvil.

### 🟠 Fase 3: Autenticación y Gestión de Sesión
1. Desarrollar formularios con validación en tiempo real y feedback visual.
2. Implementar `AuthService` (capa de abstracción de `firebase_auth`).
3. Crear `AuthProvider` con estados: `idle`, `loading`, `authenticated`, `error`.
4. Integrar flujo completo: registro, login, logout, reset password, persistencia de sesión.
5. Probar con Firebase Auth Emulator. Validar reglas de seguridad iniciales.

### 🔵 Fase 4: Capa de Datos y Providers de Negocio
1. Definir clases de modelo (`Usuario`, `Producto`, `Pedido`, etc.) con `equatable` y serialización manual o `json_serializable`.
2. Implementar `FirestoreRepository` con métodos: `create`, `getById`, `streamAll`, `update`, `delete`, `queryWithFilters`.
3. Conectar repositorios a cada Provider. Configurar streams para datos en tiempo real.
4. Implementar manejo de estados: `loading`, `data`, `error`, `empty`.
5. Validar indexación y rendimiento con consultas simuladas.

### 🟣 Fase 5: Integración de Módulos Críticos
1. **Catálogo & Productos:** Listado filtrado por categoría, búsqueda, vista detalle.
2. **Recetas & Ingredientes:** Relación `receta_ingredientes`, cálculo automático de costos, vinculación a inventario.
3. **Inventario:** Control de stock, alertas de mínimo, movimientos manuales.
4. **Pedidos & Ventas:** Carrito → creación de pedido → items → conversión a venta → cálculo de totales/descuentos.
5. Validar flujos completos con datos mock en emuladores.

### 🔴 Fase 6: Optimización, Refinamiento y QA
1. Reducir rebuilds innecesarios (`Selector`, `context.select`).
2. Implementar pull-to-refresh, paginación (`limit` + `startAfter`), caché offline básico.
3. Validar accesibilidad (contraste, navegación por teclado en Web/Windows, screen readers).
4. Ejecutar pruebas unitarias (modelos, validaciones) y de widget (UI states).
5. Ajustar reglas de Firestore para alinearse con roles y auditoría (`created_by`, `updated_by`).

---

## 10. 🧪 Estrategia de Pruebas y Validación
| Tipo | Herramienta | Objetivo |
|------|-------------|----------|
| **Unitarias** | `flutter_test`, `mockito` | Lógica de modelos, validadores, cálculo de costos/totales |
| **Widget** | `pumpWidget`, `finders` | Renderizado de pantallas, estados de carga/error, interacciones |
| **Integración** | `integration_test` | Flujos completos: login → catálogo → carrito → pedido → venta |
| **Emuladores** | Firebase Emulator Suite | Auth + Firestore sin costo, datos de prueba aislados, reglas de seguridad |
| **Multiplataforma** | AVD, Simulator, Chrome, Windows Desktop | Validación de layouts, performance, navegación táctil/mouse/teclado |

---

## 11. 🚀 Compilación y Distribución por Plataforma
| Plataforma | Comando | Output | Notas |
|------------|---------|--------|-------|
| **Android** | `flutter build apk --release` / `flutter build appbundle` | `.apk` / `.aab` | Configurar `keystore`, permisos de red, iconos adaptativos |
| **iOS** | `flutter build ios --release` (vía Xcode) | `.ipa` | Requiere macOS, certificado de desarrollo, `Info.plist` configurado |
| **Web** | `flutter build web --release` | `build/web/` | Optimizar assets, habilitar PWA básico, configurar `index.html` meta tags |
| **Windows** | `flutter build windows --release` | `build/windows/runner/Release/` | Configurar icono `.ico`, firmar ejecutable (opcional), probar DPI scaling |

> 📦 Todos los builds se ejecutarán desde scripts en `bin/`. No se incluirán servicios de telemetría ni rastreo de uso.

---

## 12. 📜 Gobernanza, Seguridad y Buenas Prácticas
- **Código:** `flutter analyze`, `dart format`, lints estrictos, commits semánticos (`feat:`, `fix:`, `refactor:`)
- **Seguridad:** Contraseñas nunca almacenadas en texto plano. Campos sensibles protegidos. Reglas de Firestore restrictivas por defecto.
- **Auditoría:** `created_by`/`updated_by` siempre poblados con `auth.uid`. Trazabilidad completa en cambios críticos.
- **Rendimiento:** Streams cancelados en `dispose`, uso de `const` donde aplique, imágenes optimizadas, lazy loading en listas.
- **Mantenimiento:** Dependencias actualizadas cada 30-60 días. Documentación de API interna y flujos en `docs/`.

---

## ✅ Siguientes Pasos Recomendados
1. Validar este plan con stakeholders y ajustar alcance de MVP.
2. Configurar entorno local + Firebase Emulator Suite.
3. Iniciar **Fase 1** (estructura + Firebase + routing).
4. Solicitar templates de pantallas, configuración de providers o reglas de seguridad específicas cuando se requiera.

Este plan está diseñado para ser ejecutable, escalable y alineado estrictamente con tus restricciones técnicas. ¿Deseas que proceda con la definición detallada de la estructura de `pubspec.yaml`, los archivos de rutas `go_router`, o la configuración inicial de `main.dart` siguiendo este esquema?

## PROMPT
CREA EL PLAN DE IMPLEMENTACION MAS PROFESIONAL Y EXTENSO basado en el anterior, en pocas palabras mejoralo.
framework:flutter dart
base de datos en la nube: console firebase, firestore
Autenticación por correo electrónico y passworf.
no usar analiticas, ni para producción.
Estructura de carpetas y archivos dentro de la carpeta bin.
aplicación para: android/web/iOS/windows
diseño UI, UX y establece que colores vas a usar en primer plano
las dependencias de pubsec.yaml
Agregar las tablas o entidades con sus atributos.
utilizar provider
agrega tambien una tabla con los colores y sus codigos para la aplicacion.
agrega la demas informacion que sea necesaria
mis tablas son las siguientes:
roles: id, nombre, descripcion, is_active, created_at, updated_at, created_by, updated_by
usuarios: id, email, password_hash, nombre_completo, telefono, rol_id, is_active, fecha_ultimo_login, created_at, updated_at, created_by, updated_by
clientes: id, nombre, email, telefono, direccion, es_empresa, notas, is_active, created_at, updated_at, created_by, updated_by
proveedores: id, nombre, contacto, email, telefono, direccion, notas, is_active, created_at, updated_at, created_by, updated_by
categorias: id, nombre, tipo, descripcion, color_hex, is_active, created_at, updated_at, created_by, updated_by
unidades_medida: id, codigo, nombre, precision_decimales, is_active, created_at, updated_at, created_by, updated_by
ingredientes: id, codigo, nombre, proveedor_id, unidad_id, costo_unitario, stock_minimo, is_active, created_at, updated_at, created_by, updated_by
recetas: id, codigo, nombre, porciones, tiempo_preparacion_min, instrucciones, costo_total, is_active, created_at, updated_at, created_by, updated_by
receta_ingredientes: id, receta_id, ingrediente_id, cantidad, unidad_id, costo_linea, orden, created_at
productos: id, codigo, nombre, categoria_id, precio_venta, costo_estimado, tiempo_preparacion_min, is_active, created_at, updated_at, created_by, updated_by
inventario: id, tipo_item, item_id, unidad_id, cantidad, stock_minimo, ubicacion, ultimo_movimiento, created_at, updated_at
pedidos: id, codigo, cliente_id, fecha_pedido, fecha_entrega_estimada, estado, total_neto, notas, created_at, updated_at, created_by, updated_by
pedido_items: id, pedido_id, producto_id, receta_id, nombre_item, cantidad, precio_unitario, total_linea, notas, created_at
ventas: id, codigo, pedido_id, cliente_id, fecha_venta, total_bruto, total_descuento, total_neto, metodo_pago, estado, created_at, created_by
