# ⚡ FastStream

> **Zero-Dependency Instant HTTP Range Video Streamer CLI**  
> Transmite cualquier archivo de video o carpeta completa por HTTP al instante en tu red local con soporte nativo de búsqueda en la línea de tiempo (*Byte-Range RFC 7233*).

---

## ✨ Características

- 🚀 **Cero Dependencias Externas:** Construido 100% con la biblioteca estándar de Python (`http.server` + `socketserver`).
- ⏩ **Seeking Ultrarrápido:** Soporte nativo de `Range: bytes=` (código HTTP `206 Partial Content`) para adelantar o retroceder al instante sin saturar memoria RAM.
- 📱 **Código QR en Terminal:** Escanea con tu móvil o tablet para empezar a ver el video en 1 segundo.
- 🎬 **Reproductor Web Moderno:** Interfaz oscura HTML5 minimalista y responsiva servida directamente en memoria.
- 📁 **Soporte de Carpetas:** Si apuntas a un directorio, genera un menú interactivo con todos los videos de la carpeta.
- 🏷️ **Extracción de Metadatos:** Detecta automáticamente resolución, duración, códec y pistas de audio.

---

## 📦 Instalación en 1 Línea

```bash
curl -sSL https://raw.githubusercontent.com/edwardrcastillo/faststream/main/install.sh | bash
```

---

## 💻 Uso

### 1. Transmitir un video individual:
```bash
faststream pelicula.mp4
```

### 2. Transmitir una carpeta de series:
```bash
faststream /media/Series/Evil/Season03/
```

### 3. Usar un puerto personalizado:
```bash
faststream pelicula.mp4 -p 8080
```

---

## 📄 Licencia
MIT License © 2026 Edward Castillo
