# ⚡ FastStream

> **Zero-Dependency Instant HTTP Range Video Streamer & Jellyfin Auditor CLI**  
> Transmite cualquier archivo de video o carpeta completa por HTTP al instante en tu red local con soporte nativo de saltos en la línea de tiempo (*Byte-Range RFC 7233*), enriquecimiento automático de carátulas TMDB y renombrado canónico para Jellyfin / FastMovie.

---

## ✨ Características Principales

- 🚀 **100% Cero Dependencias de Python:** Construido exclusivamente con la biblioteca estándar de Python (`http.server` + `socketserver` + `struct`). Cero `pip install`, cero `npm`, cero compiladores.
- 🛠️ **Funciona con o sin FFmpeg:** 
  - **Sin FFmpeg:** Funciona al 100% transmitiendo por HTTP con saltos instantáneos, scraping de TMDB, carátulas, modal interactivo, renombrado Jellyfin y lectura nativa de duración con su propio parser de átomos MP4 en Python puro.
  - **Con FFmpeg / FFprobe (Opcional):** Si está instalado en el sistema, enriquece adicionalmente la ficha técnica con la resolución exacta, códec de video y pistas de audio.
- ⏩ **Seeking Ultrarrápido (RFC 7233):** Respuestas `206 Partial Content` para adelantar o retroceder instantáneamente a cualquier segundo sin cargar el video en RAM.
- 🖼️ **Enriquecimiento Automático con TMDB:** Consulta la API de TheMovieDB en tiempo real para descargar carátulas en alta resolución, fondos de pantalla (*backdrops*), año, calificación y sinopsis oficial.
- 🔍 **Modal Interactivo de Búsqueda y Corrección:** Si el nombre del archivo es ambiguo, abre un buscador en vivo en la interfaz web para afinar título y año.
- 🏷️ **Renombrado Atómico a Estándar Jellyfin:** Renombra físicamente el archivo en el disco con 1 solo clic al formato canónico `Título (Año) [tmdbid-ID].mp4`.
- 📱 **Código QR y Detección de IP LAN:** Imprime el enlace de red local (`http://192.168.X.X:8090/`) y un código QR para abrir el streaming en teléfonos, tablets o Smart TVs en 1 segundo.
- 📁 **Navegador de Series / Carpetas:** Si apuntas a una carpeta completa, genera un menú interactivo estilo Hub para reproducir cualquier episodio.

---

## 📦 Instalación en 1 Línea (macOS & Linux)

Para instalar `faststream` como comando global del sistema:

```bash
curl -sSL https://raw.githubusercontent.com/edwardrcastillo/faststream/main/install.sh | bash
```

---

## 💻 Guía de Uso

### 1. Transmitir y auditar una película individual:
```bash
faststream "/media/Films/Patria.mp4"
```

### 2. Transmitir una temporada o carpeta completa de series:
```bash
faststream "/media/Series/Evil/Season03/"
```

### 3. Especificar un puerto personalizado:
```bash
faststream pelicula.mp4 -p 8080
```

### 4. Configurar tu propia API Key de TMDB (Opcional):
Por defecto, `faststream` incluye una clave de acceso de respaldo para funcionar de inmediato. Si prefieres usar tu propia clave oficial de TheMovieDB:

* **Guardarla de forma permanente en tu máquina (`~/.config/faststream/config.json`):**
  ```bash
  faststream --set-tmdb-key "TU_CLAVE_AQUI"
  ```
* **Usar mediante variable de entorno:**
  ```bash
  export TMDB_API_KEY="TU_CLAVE_AQUI"
  ```
* **Pasarla puntualmente como parámetro de consola:**
  ```bash
  faststream pelicula.mp4 --tmdb-key "TU_CLAVE_AQUI"
  ```

---

## 🥊 Comparativa: FastStream vs miniserve vs dufs

| Característica | ⚡ **FastStream** | 🦀 **miniserve** | 📁 **dufs** |
| :--- | :--- | :--- | :--- |
| **Lenguaje / Motor** | **Python 3 Puro** (Stdlib) | **Rust** (Actix-web) | **Rust** (Hyper / Tokio) |
| **Dependencias de Librerías** | **0 dependencias** (Cero pip/npm) | Compilado / Binario | Compilado / Binario |
| **Herramientas del Sistema** | **Ninguna obligatoria** (FFprobe opcional) | Ninguna | Ninguna |
| **Peso del Ejecutable** | **~18 KB** (Script autónomo) | Binario (~15 MB) | Binario (~6 MB) |
| **Propósito Principal** | **Streaming Multimedia, Auditoría y Renombrado** | **Compartir archivos y subidas rápidas** | **Servidor de archivos estático con WebDAV** |
| **Reproductor de Video** | 🎬 **Cinematográfico (Glassmorphism + Backdrop)** | 📄 Básico del navegador (`<video>` plano) | 📄 Básico del navegador (`<video>` plano) |
| **Metadatos y Carátulas TMDB** | ✅ **Automático + Buscador en vivo** | ❌ Inexistente | ❌ Inexistente |
| **Renombrado a Estándar Jellyfin** | ✅ **1-Click (`Título (Año) [tmdbid-ID].mp4`)** | ❌ No disponible | ❌ Solo renombrado manual plano |
| **Soporte *Range: bytes* (Seeking)** | ✅ **RFC 7233 Nativo** (<0.1s de latencia) | ✅ Soportado | ✅ Soportado |
| **Soporte WebDAV** | ❌ No (no es un disco de red) | ❌ No | ✅ **Sí** |
| **Subida de Archivos / Drag & Drop** | ❌ No (auditoría y preservación) | ✅ Sí | ✅ Sí |
| **Descarga en `.zip` / `.tar.gz`** | ❌ No | ✅ Sí | ✅ Sí |

---

## 🗺️ Roadmap de Próximas Funcionalidades

- [x] Streaming HTTP RFC 7233 con seeking instantáneo.
- [x] Integración de API TMDB con carátulas y fondos.
- [x] Modal interactivo de búsqueda y corrección de metadatos.
- [x] Renombrado físico atómico al estándar Jellyfin.
- [x] Configuración modular y persistente de API Key de TMDB.
- [x] Parser nativo de átomos MP4 en Python puro (independencia total de FFprobe).
- [ ] Selector de pistas de audio y subtítulos incrustados (SRT / ASS / VTT) en el reproductor web.
- [ ] Modo de transcodificación ligera al vuelo para códecs no soportados nativamente por navegadores (HEVC / AC3).
- [ ] Modo batch CLI (`faststream --batch-rename /carpeta/`) para renombrado masivo asistido.

---

## 📄 Licencia
MIT License © 2026 Edward Castillo
