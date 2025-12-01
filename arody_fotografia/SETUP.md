# Configuración de Arody Fotografía

## ✅ Configuración Completada

### 1. Base de Datos Supabase
- ✅ Tablas creadas y configuradas:
  - `profiles` - Perfiles de usuarios
  - `sessions` - Sesiones fotográficas
  - `session_assets` - Assets de sesiones (fotos)
  - `inspiration_items` - Galería de inspiración
  - `payments` - Pagos y facturación

### 2. Seguridad (RLS - Row Level Security)
- ✅ Políticas RLS configuradas para todas las tablas
- ✅ Los usuarios solo pueden ver sus propios datos
- ✅ Trigger automático para crear perfil al registrarse

### 3. Autenticación
- ✅ Login con email/password
- ✅ Registro de nuevos usuarios
- ✅ Logout
- ✅ Redirección automática según estado de autenticación

### 4. Arquitectura Clean Architecture
```
lib/
├── core/                   # Utilidades compartidas
│   ├── constants/         # Constantes de Supabase
│   └── theme/             # Tema de la app
├── data/                   # Capa de datos
│   ├── models/            # DTOs con serialización JSON
│   └── repositories/      # Implementaciones de repositorios
├── domain/                 # Lógica de negocio
│   ├── entities/          # Entidades del dominio
│   └── repositories/      # Interfaces de repositorios
└── presentation/           # Capa de UI
    ├── providers/         # Riverpod providers
    ├── router/            # Navegación con GoRouter
    └── screens/           # Pantallas de la app
```

### 5. State Management
- ✅ Riverpod con code generation
- ✅ Providers para Auth, Profile, Sessions, Payments, Inspiration
- ✅ Manejo de estados asíncronos (loading, error, data)

### 6. Modelos y Entidades
Todas las entidades tienen sus modelos correspondientes con serialización JSON:
- ✅ Profile
- ✅ Session
- ✅ SessionAsset
- ✅ Payment
- ✅ InspirationItem

## 🚀 Cómo Ejecutar

### Prerrequisitos
- Flutter SDK (3.9.2 o superior)
- Cuenta de Supabase configurada

### Pasos

1. **Instalar dependencias**
```bash
cd arody_fotografia
flutter pub get
```

2. **Generar código (providers y modelos)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. **Ejecutar la aplicación**
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome
```

## 🔐 Configuración de Supabase

Las credenciales de Supabase están configuradas en:
`lib/core/constants/supabase_constants.dart`

**URL del proyecto:** https://iwdmagyoefjanvapgmpb.supabase.co

Para mayor seguridad en producción, usa variables de entorno:
```bash
flutter run --dart-define=SUPABASE_URL=tu_url --dart-define=SUPABASE_ANON_KEY=tu_key
```

## 📱 Funcionalidades Implementadas

### Autenticación
- [x] Login
- [x] Registro
- [x] Logout
- [x] Creación automática de perfil

### Perfil de Usuario
- [x] Modelo y repositorio
- [x] Pantalla de configuración de perfil
- [x] Actualización de información

### Sesiones Fotográficas
- [x] Listar sesiones del usuario
- [x] Ver detalles de sesión
- [x] Crear nueva sesión (booking)

### Inspiración
- [x] Galería de inspiración
- [x] Filtrado por categorías
- [x] Vista detallada

### Pagos
- [x] Listar pagos del usuario
- [x] Ver estado de pagos (pendiente/pagado/vencido)

## 🔒 Seguridad

### Políticas RLS Configuradas

**profiles:**
- Los usuarios pueden ver su propio perfil
- Los usuarios pueden actualizar su propio perfil
- Los usuarios pueden insertar su propio perfil

**sessions:**
- Los usuarios pueden ver sus propias sesiones
- Los usuarios pueden crear solicitudes de booking

**session_assets:**
- Los usuarios pueden ver los assets de sus propias sesiones

**payments:**
- Los usuarios pueden ver sus propios pagos

**inspiration_items:**
- Todos pueden ver los items de inspiración (público)

## 📝 Próximos Pasos

### Recomendaciones para Desarrollo

1. **Habilitar confirmación de email**
   - En Supabase Dashboard → Authentication → Settings
   - Configurar email templates personalizados

2. **Configurar Storage para fotos**
   - Crear buckets para session_assets
   - Configurar políticas de acceso

3. **Agregar validación de contraseñas comprometidas**
   - Dashboard → Auth → Password Protection
   - Habilitar "Leaked Password Protection"

4. **Testing**
   - Agregar tests unitarios para repositorios
   - Agregar tests de widget para pantallas principales

5. **Mejoras de UX**
   - Agregar shimmer effects para loading
   - Mejorar manejo de errores
   - Agregar confirmaciones para acciones importantes

## 🐛 Troubleshooting

### Error: "User not logged in"
- Asegúrate de que el usuario esté autenticado
- Verifica que el token de sesión no haya expirado

### Error: "Row Level Security"
- Verifica que las políticas RLS estén habilitadas
- Revisa que el usuario tenga permisos para la operación

### Build Runner Errors
```bash
# Limpiar y regenerar
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📚 Recursos

- [Documentación de Supabase](https://supabase.com/docs)
- [Documentación de Riverpod](https://riverpod.dev)
- [Documentación de GoRouter](https://pub.dev/packages/go_router)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)

