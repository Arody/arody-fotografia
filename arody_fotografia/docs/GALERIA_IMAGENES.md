# Galería de Imágenes de Sesiones

## Descripción

Esta funcionalidad permite mostrar una galería de imágenes en el detalle de cada sesión, donde los clientes pueden ver y descargar las fotos de su sesión.

## Características Implementadas

### 1. Storage Bucket en Supabase
- **Nombre del bucket**: `session-photos`
- **Privacidad**: Privado - Solo el cliente de la sesión puede ver sus imágenes
- **Tipos de archivo permitidos**: JPEG, JPG, PNG, WebP
- **Tamaño máximo por archivo**: 10MB
- **Organización**: 
  - `{session_id}/thumbnails/` - Miniaturas para preview (recomendado max 400px)
  - `{session_id}/full/` - Imágenes en resolución completa para descarga

### 2. Funcionalidades del Cliente
- Ver galería de imágenes en el detalle de cada sesión
- Tap en miniatura para ver imagen en pantalla completa
- Zoom y pan en la imagen completa (usando gestos de pellizco)
- Botón de descarga para guardar la imagen en la galería del dispositivo
- Notificación de éxito/error al descargar

### 3. Seguridad (RLS Policies)
- Los clientes solo pueden ver imágenes de sus propias sesiones
- Solo el service role puede subir, actualizar o eliminar imágenes
- URLs firmadas con expiración de 1 hora

## Cómo Subir Imágenes (Manualmente vía Supabase Dashboard)

### Paso 1: Preparar las Imágenes

1. Para cada sesión, prepara dos versiones de cada imagen:
   - **Thumbnail**: Máximo 400px de ancho (para carga rápida en la galería)
   - **Full**: Resolución completa (para descarga)

### Paso 2: Subir al Storage

1. Ve al Dashboard de Supabase: https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Ve a Storage en el menú lateral
4. Selecciona el bucket `session-photos`
5. Crea la estructura de carpetas para una sesión:
   ```
   {session_id}/
   ├── thumbnails/
   │   ├── foto1.jpg
   │   ├── foto2.jpg
   │   └── ...
   └── full/
       ├── foto1.jpg
       ├── foto2.jpg
       └── ...
   ```
   
   **Nota**: Reemplaza `{session_id}` con el UUID de la sesión correspondiente

6. Sube las imágenes a las carpetas correspondientes

### Paso 3: Registrar en la Base de Datos

1. Ve a la sección "Table Editor" en el dashboard
2. Selecciona la tabla `session_assets`
3. Para cada imagen, inserta un registro con:
   - `id`: Se genera automáticamente
   - `session_id`: UUID de la sesión
   - `storage_path`: Ruta al thumbnail (ej: `{session_id}/thumbnails/foto1.jpg`)
   - `asset_type`: Tipo de asset ('preview', 'final', o 'bts')
   - `created_at`: Se genera automáticamente

**Ejemplo de SQL para insertar múltiples registros:**

```sql
INSERT INTO public.session_assets (session_id, storage_path, asset_type)
VALUES
  ('SESSION_UUID_AQUI', 'SESSION_UUID_AQUI/thumbnails/foto1.jpg', 'final'),
  ('SESSION_UUID_AQUI', 'SESSION_UUID_AQUI/thumbnails/foto2.jpg', 'final'),
  ('SESSION_UUID_AQUI', 'SESSION_UUID_AQUI/thumbnails/foto3.jpg', 'final');
```

## Cómo Obtener el Session ID

1. Ve a "Table Editor" > "sessions" en el dashboard de Supabase
2. Busca la sesión correspondiente
3. Copia el valor del campo `id` (es un UUID)

## Convención de Nombres

Se recomienda usar nombres descriptivos para las imágenes:
- `foto1.jpg`, `foto2.jpg`, etc.
- O nombres descriptivos como `retrato_perfil.jpg`, `grupo_familia.jpg`

**Importante**: Los nombres deben ser idénticos entre thumbnails y full (ej: `thumbnails/foto1.jpg` y `full/foto1.jpg`)

## Permisos Necesarios en la App

La aplicación solicitará permisos de almacenamiento/fotos cuando el usuario intente descargar una imagen por primera vez.

### iOS
Ya configurado en `Info.plist` (si es necesario agregar):
```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Necesitamos acceso a tu biblioteca de fotos para guardar las imágenes descargadas</string>
```

### Android
Ya configurado en `AndroidManifest.xml` (si es necesario agregar):
```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

## Troubleshooting

### Las imágenes no se muestran
- Verifica que el bucket `session-photos` existe
- Verifica que las imágenes están en la ruta correcta
- Verifica que existe un registro en `session_assets` con el `storage_path` correcto
- Verifica que el usuario está autenticado y es el cliente de esa sesión

### Error al descargar
- Verifica que el usuario ha otorgado permisos de almacenamiento
- Verifica que la imagen existe en la carpeta `full/`

### No se puede subir imágenes
- Actualmente, solo se pueden subir imágenes manualmente vía dashboard
- Asegúrate de estar usando el service role o un usuario con permisos adecuados

## Mejoras Futuras Sugeridas

1. **Panel de Administración en la App**: Permitir al fotógrafo subir imágenes desde la app
2. **Compresión Automática**: Generar thumbnails automáticamente al subir
3. **Marca de Agua**: Agregar marca de agua a las previews
4. **Selección Múltiple**: Permitir descargar múltiples imágenes a la vez
5. **Notificaciones**: Notificar al cliente cuando se agregan nuevas fotos a su sesión

