# 📱 Plan de Implementación: Aplicación "Repostería" (Flutter + Firebase)

> **Nota:** Este documento es un plan de desarrollo estructurado. No contiene código. Su objetivo es servir como guía paso a paso para el equipo o desarrollador antes de iniciar la escritura del proyecto.

---

## 🛠️ Fase 1: Configuración del Entorno de Desarrollo

| Paso | Acción | Entregable |
|------|--------|------------|
| 1.1 | Instalar Flutter SDK y Dart SDK (versión estable más reciente) | `flutter doctor` sin errores críticos |
| 1.2 | Instalar VS Code (recomendado) o Android Studio. Añadir extensiones: Flutter, Dart, Firebase, GitLens, Error Lens | IDE listo con autocompletado y diagnóstico |
| 1.3 | Configurar emuladores/dispositivos físicos (Android & iOS) y verificar hot reload | Dispositivo conectado y funcionando |
| 1.4 | Inicializar repositorio Git y definir ramas (`main`, `develop`, `feature/*`) | Estructura de control de versiones activa |
| 1.5 | Crear proyecto Flutter: `flutter create reposteria_app` y verificar estructura base | Proyecto compilable en modo debug |

---

## 🎨 Fase 2: Diseño UI/UX y Arquitectura Base

| Paso | Acción | Entregable |
|------|--------|------------|
| 2.1 | Definir flujos de usuario: Registro/Login → Catálogo → Detalle → Carrito → Pedido → Perfil | Mapa de navegación y user journey |
| 2.2 | Crear wireframes de baja fidelidad (papel/FigJam) y validar lógica de pantallas | Documento de flujos aprobado |
| 2.3 | Diseñar UI de alta fidelidad en Figma: paleta de colores, tipografía, espaciado, componentes reutilizables (cards, botones, inputs, loaders) | Kit de diseño y especificaciones de estilo |
| 2.4 | Definir arquitectura: **MVVM + Provider**. Separar en capas: `presentation`, `domain`, `data`, `core` | Estructura de carpetas documentada |
| 2.5 | Planificar sistema de rutas: `go_router` o `AutoRoute` (si se requiere navegación avanzada) | Árbol de rutas y guards de autenticación |

---

## 📦 Fase 3: Dependencias y Configuración de Firebase

### 📋 Dependencias recomendadas para `pubspec.yaml`
| Categoría | Paquete | Propósito |
|-----------|---------|-----------|
| Core Firebase | `firebase_core` | Inicialización de Firebase |
| Autenticación | `firebase_auth` | Login/Registro email-password |
| Base de datos | `cloud_firestore` | Persistencia de productos, pedidos, usuarios |
| Estado | `provider` | Gestión de estado global y reactivo |
| UI/UX | `google_fonts`, `flutter_screenutil`, `cached_network_image`, `lottie` | Tipografía, responsividad, imágenes, animaciones |
| Utilidades | `intl`, `uuid`, `shared_preferences`, `formz` o `flutter_form_builder` | Formateo, IDs únicos, almacenamiento local, validación de formularios |
| Dev/Debug | `flutter_lints`, `mocktail`, `bloc_test` (opcional), `firebase_crashlytics`, `firebase_analytics` | Calidad, testing y monitoreo |

### 🔥 Configuración Firebase
| Paso | Acción |
|------|--------|
| 3.1 | Crear proyecto en Firebase Console |
| 3.2 | Habilitar **Authentication** → Método Email/Password |
| 3.3 | Crear base de datos **Firestore** en modo prueba (luego ajustar reglas) |
| 3.4 | Instalar `flutterfire_cli`, ejecutar `flutterfire configure` para generar archivos de configuración por plataforma |
| 3.5 | Definir estructura de colecciones Firestore: `users`, `products`, `categories`, `orders`, `cart_items` |
| 3.6 | Configurar reglas de seguridad básicas y índices compuestos necesarios |

---

## 🧱 Fase 4: Desarrollo Paso a Paso (Implementación Modular)

### 🔹 Módulo 4.1: Arquitectura Base y State Management
1. Configurar `MultiProvider` en `main.dart` con los `ChangeNotifier` iniciales (`AuthProvider`, `ProductProvider`, `CartProvider`, `UIProvider`).
2. Crear carpeta `lib/core` para constantes, temas, utilidades y enrutador.
3. Implementar `ThemeData` basado en el diseño Figma (light/dark ready).
4. Verificar que la app compile y renderice un `Scaffold` vacío con navegación base.

### 🔹 Módulo 4.2: Autenticación (Email/Password)
1. Crear formularios de Login y Registro con validación en tiempo real.
2. Implementar `AuthService` que envuelva `firebase_auth` (métodos: `signIn`, `signUp`, `signOut`, `recoverPassword`, `currentUser`).
3. Conectar formularios con Provider mediante `AuthNotifier`.
4. Manejar estados: loading, success, error (mostrar SnackBars/Dialogs).
5. Implementar guard de ruta: si no hay sesión, redirigir a Login; si hay sesión, ir a Home.

### 🔹 Módulo 4.3: Catálogo de Productos (Firestore + UI)
1. Diseñar `ProductCard` y `ProductDetailScreen`.
2. Crear `ProductRepository` para leer/escribir en `cloud_firestore`.
3. Implementar `ProductNotifier` con métodos: `loadProducts()`, `search()`, `filterByCategory()`.
4. Mostrar lista con `ListView.builder` + `StreamBuilder` o `FutureBuilder` (recomendado: `Stream` para tiempo real).
5. Añadir pull-to-refresh, paginación o `Firestore` limit/offset.

### 🔹 Módulo 4.4: Carrito y Flujo de Pedido
1. Modelar `CartItem` (producto, cantidad, variantes, precio).
2. Implementar `CartNotifier` con operaciones: `add()`, `remove()`, `updateQuantity()`, `clear()`, `calculateTotal()`.
3. Persistir carrito localmente con `shared_preferences` o Firestore (según requisito de sync multi-dispositivo).
4. Diseñar pantallas: `CartScreen`, `CheckoutScreen`, `OrderConfirmationScreen`.
5. Validar stock/dirección/método de pago antes de crear pedido.

### 🔹 Módulo 4.5: Perfil de Usuario y Configuración
1. Mostrar datos del usuario autenticado (nombre, email, foto si aplica).
2. Permitir edición de perfil (nombre, teléfono, dirección).
3. Crear sección de historial de pedidos (consulta Firestore `orders` filtrada por `userId`).
4. Opción de cierre de sesión segura y limpieza de estado local.

### 🔹 Módulo 4.6: UX Refinada y Manejo de Errores
1. Implementar skeletons/loaders para carga asíncrona.
2. Crear gestor global de errores (`ErrorBoundary` o `try/catch` centralizado).
3. Añadir animaciones de transición, feedback háptico y estados vacíos.
4. Optimizar imágenes con `cached_network_image` y formatos webp.
5. Validar accesibilidad (contrastes, tamaños de texto, semántica).

---

## 🧪 Fase 5: Pruebas, Optimización y Despliegue

| Etapa | Acción |
|-------|--------|
| 5.1 | **Unit Tests:** Validar lógica de `ChangeNotifier`, validaciones de formularios, cálculos de carrito |
| 5.2 | **Widget Tests:** Verificar renderizado de pantallas clave y respuestas a interacciones |
| 5.3 | **Integration Tests:** Flujo completo Login → Catálogo → Carrito → Pedido |
| 5.4 | **Optimización:** Revisar queries Firestore, reducir rebuilds con `Consumer`/`Selector`, evitar `setState` innecesario |
| 5.5 | **Seguridad:** Ajustar reglas Firestore (solo lectura pública de productos, escritura restringida a usuarios autenticados) |
| 5.6 | **Build:** Generar APK/AAB (Android) e IPA (iOS) con firma release, configurar iconos y splash |
| 5.7 | **Despliegue:** Subir a Play Console y App Store Connect, configurar CI/CD opcional (GitHub Actions/Codemagic) |
| 5.8 | **Post-Launch:** Activar Crashlytics y Analytics, monitorear retención y crashes |

---

## 📌 Consideraciones Clave para "Repostería"

- 🍰 **Modelo de datos:** Los productos deben soportar variantes (tamaño, sabor, relleno) y disponibilidad por horario.
- 🔒 **Seguridad:** Nunca almacenar contraseñas. Usar `firebase_auth` nativo. Validar reglas Firestore con `request.auth != null`.
- 🌐 **Offline-first:** Configurar `enablePersistence()` en Firestore si se requiere funcionamiento sin conexión.
- 📱 **Responsividad:** Usar `LayoutBuilder`, `MediaQuery` o `flutter_screenutil` para adaptar a móviles y tablets.
- ♿ **Accesibilidad:** Etiquetas semánticas, contraste WCAG AA, soporte para escalado de texto del sistema.

---

## ✅ Siguientes Pasos

1. Revisar y aprobar este plan.
2. Confirmar si se requiere integración con pasarela de pago, notificaciones push o panel admin.
3. Solicitar el **código por fase** (ej: "Genera solo el Módulo 4.2: Autenticación con Provider y Firebase Auth").
4. Establecer hitos de revisión y entregas parciales.
