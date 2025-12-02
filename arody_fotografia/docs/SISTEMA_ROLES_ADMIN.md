# Sistema de Roles y Gestión de Fotos para Administradores

## Descripción General

Este sistema implementa dos roles diferenciados:
- **client**: Usuarios normales que pueden ver y descargar fotos de sus propias sesiones
- **super_admin**: Administradores que pueden ver todas las sesiones, cargar fotos masivamente y eliminar fotos

## Características Implementadas

### 1. Sistema de Roles

#### Base de Datos
- Campo `role` agregado a la tabla `profiles` con valores: `'client'` (default) o `'super_admin'`
- Políticas RLS actualizadas para permitir a super_admin acceder a todo

#### Entidad Profile
```dart
class Profile {
  final String role; // 'client' o 'super_admin'
  
  bool get isAdmin => role == 'super_admin';
  bool get isClient => role == 'client';
}
```

### 2. Permisos por Rol

#### Cliente (role: 'client')
- ✅ Ver solo sus propias sesiones
- ✅ Ver fotos de sus sesiones
- ✅ Descargar fotos de sus sesiones
- ✅ Hacer zoom en las fotos
- ✅ Reservar nuevas sesiones
- ❌ No puede cargar fotos
- ❌ No puede eliminar fotos
- ❌ No puede ver sesiones de otros clientes

#### Super Admin (role: 'super_admin')
- ✅ Ver TODAS las sesiones de todos los clientes
- ✅ Ver fotos de cualquier sesión
- ✅ Cargar fotos masivamente (desde carpeta)
- ✅ Eliminar fotos individuales
- ✅ Descargar fotos
- ✅ Badge "ADMIN" en la interfaz
- ❌ No puede reservar sesiones (es administrador, no cliente)

### 3. Funcionalidades de Admin

#### Cargar Fotos Masivamente
1. En el detalle de cualquier sesión, el admin ve un botón flotante "Cargar Fotos"
2. Al hacer clic, se abre un diálogo para seleccionar múltiples imágenes
3. El sistema automáticamente:
   - Genera thumbnails (400px ancho, calidad 85%)
   - Sube las imágenes en resolución completa a `{session_id}/full/`
   - Sube los thumbnails a `{session_id}/thumbnails/`
   - Registra cada imagen en la tabla `session_assets`
4. Muestra progreso de carga (ej: "Subiendo 3 de 10...")

#### Eliminar Fotos
1. En cada thumbnail de la galería, el admin ve un botón rojo de eliminar (esquina superior derecha)
2. Al hacer clic, solicita confirmación
3. Al confirmar, elimina:
   - La imagen full resolution
   - El thumbnail
   - El registro de la base de datos

#### Ver Todas las Sesiones
1. En la pantalla de lista de sesiones, el admin ve:
   - Badge "ADMIN" en el AppBar
   - Título: "Todas las Sesiones" (en lugar de "Mis Sesiones")
   - TODAS las sesiones de todos los clientes
   - No tiene botón para reservar sesiones

## Asignar Rol de Super Admin

### Método 1: Directamente en Supabase Dashboard

1. Ve a: https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Ve a "Table Editor" > "profiles"
4. Busca el usuario que deseas hacer admin
5. Edita el registro y cambia el campo `role` a `'super_admin'`
6. Guarda los cambios

### Método 2: SQL Query

Ejecuta esta query en el SQL Editor de Supabase:

```sql
-- Asignar rol de super_admin a un usuario específico
UPDATE public.profiles 
SET role = 'super_admin' 
WHERE id = 'USER_UUID_AQUI';

-- Verificar el cambio
SELECT id, full_name, role 
FROM public.profiles 
WHERE role = 'super_admin';
```

Para obtener el UUID del usuario:
```sql
-- Listar todos los usuarios con su información
SELECT 
  p.id,
  p.full_name,
  p.role,
  au.email
FROM public.profiles p
INNER JOIN auth.users au ON au.id = p.id;
```

### Método 3: Crear un Usuario Admin desde Cero

```sql
-- 1. Primero, crea el usuario en Auth (hazlo desde el dashboard de Authentication)
-- 2. Luego, actualiza su perfil para que sea admin
UPDATE public.profiles 
SET role = 'super_admin' 
WHERE id = (
  SELECT id FROM auth.users WHERE email = 'admin@ejemplo.com'
);
```

## Estructura de Archivos en Storage

### Organización
```
storage/
  session-photos/
    {session-uuid-1}/
      full/
        - photo_1701234567890_0.jpg  (full resolution)
        - photo_1701234567891_1.jpg
        - photo_1701234567892_2.jpg
      thumbnails/
        - photo_1701234567890_0.jpg  (400px ancho)
        - photo_1701234567891_1.jpg
        - photo_1701234567892_2.jpg
    {session-uuid-2}/
      full/
        ...
      thumbnails/
        ...
```

### Nomenclatura de Archivos
- Formato: `photo_{timestamp}_{index}.{extension}`
- Ejemplo: `photo_1701234567890_0.jpg`
- El timestamp y el índice evitan colisiones de nombres

## Flujo de Trabajo para el Administrador

### Subir Fotos a una Sesión

1. **Preparar las fotos**:
   - Ten las fotos listas en una carpeta en tu dispositivo
   - No necesitas crear thumbnails manualmente (se generan automáticamente)

2. **Acceder a la sesión**:
   - Abre la app
   - Ve a "Todas las Sesiones"
   - Encuentra y abre la sesión correspondiente

3. **Cargar las fotos**:
   - Toca el botón flotante "Cargar Fotos"
   - Selecciona múltiples fotos desde tu galería/archivos
   - Revisa las fotos seleccionadas
   - Toca "Subir"
   - Espera a que termine la carga (verás el progreso)

4. **Verificar**:
   - Las fotos aparecerán automáticamente en la galería
   - El cliente podrá verlas y descargarlas inmediatamente

### Eliminar una Foto

1. Abre la sesión correspondiente
2. En la galería, localiza la foto a eliminar
3. Toca el ícono rojo de eliminar (esquina superior derecha del thumbnail)
4. Confirma la eliminación
5. La foto se eliminará inmediatamente

## Seguridad (RLS Policies)

### Sesiones
```sql
-- Clientes ven solo sus sesiones, admins ven todo
CREATE POLICY "Users can view own sessions or admin can view all" 
ON public.sessions FOR SELECT 
USING (
  auth.uid() = client_id 
  OR 
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
);
```

### Session Assets (Registros DB)
```sql
-- Ver assets: clientes sus propias sesiones, admins todo
CREATE POLICY "Users can view own session assets or admin can view all" 
ON public.session_assets FOR SELECT 
USING (...);

-- Insertar: solo admins
CREATE POLICY "Super admin can insert session assets" 
ON public.session_assets FOR INSERT 
WITH CHECK (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
);

-- Eliminar: solo admins
CREATE POLICY "Super admin can delete session assets" 
ON public.session_assets FOR DELETE 
USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
);
```

### Storage (Archivos Físicos)
```sql
-- Ver fotos: clientes sus propias sesiones, admins todo
CREATE POLICY "Users can view own session photos"
ON storage.objects FOR SELECT
USING (...);

-- Subir/Actualizar/Eliminar: solo admins
CREATE POLICY "Super admin can upload photos" 
ON storage.objects FOR INSERT 
WITH CHECK (
  bucket_id = 'session-photos'
  AND EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
);
```

## Providers y Estado

### Providers Principales

```dart
// Verificar si el usuario actual es admin
final isAdmin = await ref.watch(isCurrentUserAdminProvider.future);

// Obtener todas las sesiones (solo para admin)
final allSessions = ref.watch(allSessionsListProvider);

// Obtener sesiones del usuario (para cliente)
final mySessions = ref.watch(sessionsListProvider);

// Estado de carga de fotos
final uploadState = ref.watch(photoUploadProvider);

// Cargar fotos
await ref.read(photoUploadProvider.notifier).uploadPhotos(sessionId, photos);

// Eliminar foto
await ref.read(photoUploadProvider.notifier).deletePhoto(assetId);
```

## Troubleshooting

### Las fotos no se cargan
- Verifica que el usuario tiene rol `'super_admin'` en la tabla profiles
- Verifica que las políticas RLS están activas
- Revisa los logs de Supabase para ver errores de permisos

### El botón "Cargar Fotos" no aparece
- Verifica que el usuario está correctamente autenticado
- Verifica que el rol es `'super_admin'` exactamente (case-sensitive)
- Cierra y vuelve a abrir la sesión

### Error al eliminar fotos
- Verifica que el archivo existe tanto en `/full/` como en `/thumbnails/`
- Verifica permisos de storage
- Revisa que el registro existe en `session_assets`

### No se ven todas las sesiones en modo admin
- Verifica que el provider `allSessionsListProvider` está siendo usado
- Verifica que la política RLS permite al admin ver todas las sesiones
- Refresca la pantalla con pull-to-refresh

## Próximas Mejoras Sugeridas

1. **Notificaciones**: Notificar al cliente cuando se agregan nuevas fotos a su sesión
2. **Compresión Configurable**: Permitir al admin configurar la calidad de compresión
3. **Edición de Fotos**: Permitir rotación, recorte básico antes de subir
4. **Comentarios**: Permitir al admin agregar comentarios a las fotos
5. **Selección de Favoritas**: Permitir al cliente marcar sus fotos favoritas
6. **Álbumes**: Organizar fotos en álbumes dentro de una sesión
7. **Compartir Sesión**: Generar link temporal para compartir la sesión sin autenticación
8. **Estadísticas**: Panel de estadísticas para el admin (fotos por sesión, descargas, etc.)

