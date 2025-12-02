# Assets - Splash Screen Logo

## Agregar tu logo personalizado

Para personalizar el splash screen con tu propio logo:

### 1. Prepara tu logo
- **Formato**: PNG con fondo transparente
- **Tamaño recomendado**: 512x512px o 1024x1024px
- **Contenido**: Logo simple y limpio que contraste con el fondo negro

### 2. Guarda el archivo
Copia tu logo en esta carpeta con el nombre:
```
splash_logo.png
```

### 3. Actualiza el pubspec.yaml
Descomenta las líneas de imagen en la sección `flutter_native_splash`:

```yaml
flutter_native_splash:
  color: "#000000"
  color_dark: "#000000"
  
  # Descomenta estas líneas:
  image: assets/images/splash_logo.png
  image_dark: assets/images/splash_logo.png
  
  android_12:
    color: "#000000"
    # icon_background_color: "#00B074"  # Opcional: color de acento
    # Descomenta esta línea:
    image: assets/images/splash_logo.png
```

### 4. Regenera el splash screen
Ejecuta en la terminal:
```bash
dart run flutter_native_splash:create
```

### 5. Reinicia la app
```bash
flutter clean
flutter pub get
flutter run
```

## Colores del tema
- **Primary Color**: #000000 (Negro)
- **Accent Color**: #00B074 (Verde)
- **Background**: #F6F6F6 (Gris claro)

El splash screen actual usa el color negro (#000000) como fondo, que coincide con el `primaryColor` del tema de la app.

