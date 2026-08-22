# ⚡ FastStream

> **Zero-Dependency Instant HTTP Range Video Streamer, Multi-Audio/Subtitles Hub & Jellyfin Auditor CLI**  
> Transmite cualquier archivo de video o carpeta completa por HTTP al instante en tu red local con soporte nativo de saltos en la línea de tiempo (*Byte-Range RFC 7233*), **conmutador de pistas de audio y subtítulos en vivo**, enriquecimiento automático de carátulas TMDB/IMDb, renombrado canónico Jellyfin y control de apagado remoto.

---

## ✨ Características Principales

- 🚀 **100% Cero Dependencias de Python:** Construido exclusivamente con la biblioteca estándar de Python 3 (`http.server` + `socketserver` + `struct` + `urllib`). Cero `pip install`, cero `npm`, cero compiladores pesados.
- 🎵 **Selector de Pistas de Audio al Vuelo:** Conmuta entre pistas de audio (Español Latino, Japonés, Inglés, 5.1 Surround, Estéreo) directamente desde el reproductor web. Si se cambia de pista, el servidor realiza remuxing en streaming sin perder la posición de reproducción (`currentTime`).
- 💬 **Soporte Dinámico de Subtítulos (WebVTT On-Demand):** Detecta subtítulos incrustados (`SubRip / SRT`, `mov_text`, `ASS`, `VTT`) y archivos `.srt` externos adyacentes, sirviéndolos como WebVTT en vivo con opción de activar, desactivar o cambiar idioma en 1 clic.
- 🛑 **Apagado Remoto desde el Navegador:** Botón integrado `🛑 Apagar` en la web para detener el servidor CLI y liberar el puerto desde tu celular, Smart TV, tablet o PC sin tener que ir a la consola.
- 📱 **Código QR Nativo en Terminal:** Generador matemático en Python puro (Reed-Solomon GF(256)) que dibuja el código QR directamente en la consola para escanear con la cámara y abrir el video al instante.
- ⚡ **Asignación Inteligente de Puertos (Multi-Instancia):** Si el puerto base `8090` está ocupado, busca automáticamente el siguiente puerto libre (`8091`, `8092`...), permitiendo múltiples transmisiones simultáneas.
- 🛠️ **Funciona con o sin FFmpeg:** 
  - **Sin FFmpeg:** Transmite por HTTP con saltos instantáneos, scraping de TMDB, carátulas, modal interactivo, renombrado Jellyfin y lectura nativa de duración con su propio parser de átomos MP4 en Python puro.
  - **Con FFmpeg / FFprobe (Opcional):** Enriquece la ficha técnica con resolución, códec, pistas de audio con canales e inyección de subtítulos WebVTT.
- ⏩ **Seeking Ultrarrápido (RFC 7233):** Respuestas `206 Partial Content` para adelantar o retroceder instantáneamente a cualquier segundo sin cargar el video en RAM.
- 🖼️ **Enriquecimiento Automático con TMDB e IMDb:** Consulta TheMovieDB en tiempo real para descargar carátulas en alta resolución, fondos de pantalla (*backdrops*), año, calificación y sinopsis oficial. Soporta búsqueda por texto, TMDB ID, IMDb ID (`ttXXXXXXX`) y enlaces completos.
- 🌐 **Selector de Variantes de Idioma en 1 Clic:** Permite elegir entre el título en Español (Latinoamérica / España), Inglés o idioma Original antes de aplicar el renombrado.
- 🏷️ **Renombrado Atómico a Estándar Jellyfin:** Renombra físicamente el archivo en el disco con 1 solo clic al formato canónico `Título (Año) [tmdbid-ID].ext`.
- 📁 **Navegador de Series / Catálogo de Carpetas:** Si apuntas a una carpeta completa, genera un Hub interactivo estilo Netflix con buscador en vivo (atajo de teclado `/`) para reproducir cualquier episodio.
- 🔄 **Actualización Integrada en 1 Comando (`--update`):** Actualiza el ejecutable global al instante con las últimas mejoras del repositorio.

---

## 📦 Instalación y Actualización

### 📥 Instalación en 1 Línea (macOS & Linux):

```bash
curl -sSL https://raw.githubusercontent.com/edwardrcastillo/faststream/main/install.sh | bash
```

### 🔄 Actualización a la Versión Más Reciente:

Cuando ya tengas `faststream` instalado y desees actualizarlo manualmente:

* **Opción 1 (Directo desde el CLI):**
  ```bash
  faststream --update
  ```
* **Opción 2 (Mediante script remoto en 1 línea):**
  ```bash
  curl -sSL https://raw.githubusercontent.com/edwardrcastillo/faststream/main/update.sh | bash
  ```
* **Opción 3 (Desde el repositorio local clonado):**
  ```bash
  bash scripts/update_faststream.sh
  ```

---

## 💻 Guía de Uso

### 1. Transmitir y auditar una película individual:
```bash
faststream "/media/Films/Patria (2024).mp4"
```

### 2. Transmitir una temporada o carpeta completa de series:
```bash
faststream "/media/Series/One Piece/Season 18/"
```

### 3. Especificar puerto manualmente:
```bash
faststream video.mp4 -p 9000
```

### 4. Actualizar FastStream:
```bash
faststream --update
```

### 5. Detener el servidor:
* **Desde la terminal:** Presionando `Ctrl + C`.
* **Desde el navegador:** Haciendo clic en el botón rojo **"🛑 Apagar"** en la interfaz web.

### 6. Configurar tu propia API Key de TMDB (Opcional):
Por defecto, `faststream` incluye una clave de acceso de respaldo para funcionar de inmediato. Si prefieres usar tu propia clave oficial de TheMovieDB:

* **Guardarla de forma permanente (`~/.config/faststream/config.json`):**
  ```bash
  faststream --set-tmdb-key "TU_CLAVE_AQUI"
  ```
* **Usar mediante variable de entorno:**
  ```bash
  export TMDB_API_KEY="TU_CLAVE_AQUI"
  ```
* **Pasarla puntualmente como parámetro:**
  ```bash
  faststream pelicula.mp4 --tmdb-key "TU_CLAVE_AQUI"
  ```

---

## 🥊 Comparativa: FastStream vs miniserve vs dufs

| Característica | ⚡ **FastStream v2.1** | 🦀 **miniserve** | 📁 **dufs** |
| :--- | :--- | :--- | :--- |
| **Lenguaje / Motor** | **Python 3 Puro** (Stdlib) | **Rust** (Actix-web) | **Rust** (Hyper / Tokio) |
| **Dependencias de Librerías** | **0 dependencias** (Cero pip/npm) | Binario compilado | Binario compilado |
| **Herramientas del Sistema** | **Ninguna obligatoria** (FFprobe opcional) | Ninguna | Ninguna |
| **Pistas de Audio al Vuelo** | ✅ **Conmutador Multi-Audio en vivo** | ❌ No | ❌ No |
| **Selector de Subtítulos** | ✅ **Incrustados + Externos (WebVTT)** | ❌ No | ❌ No |
| **Apagado Remoto desde Web** | ✅ **1-Click (`🛑 Apagar Servidor`)** | ❌ Solo `Ctrl+C` en consola | ❌ Solo `Ctrl+C` en consola |
| **Multi-Instancia Automática** | ✅ **Auto-Port Hunting (8090, 8091...)** | ❌ Falla con `Port in use` | ❌ Falla con `Port in use` |
| **Código QR en Consola** | ✅ **Nativo en Python Puro** | ✅ Requiere flag | ❌ No |
| **Peso del Ejecutable** | **~89 KB** (Script autónomo único) | Binario (~15 MB) | Binario (~6 MB) |
| **Propósito Principal** | **Streaming Multimedia, Auditoría y Renombrado** | **Compartir archivos y subidas** | **Servidor de archivos / WebDAV** |
| **Reproductor de Video** | 🎬 **Cinematográfico (Glassmorphism + Tracks)** | 📄 Básico del navegador (`<video>` plano) | 📄 Básico del navegador (`<video>` plano) |
| **Metadatos y Carátulas TMDB/IMDb** | ✅ **Automático + Buscador en vivo** | ❌ Inexistente | ❌ Inexistente |
| **Selector Variantes de Título** | ✅ **Español, Inglés u Original en 1 clic** | ❌ Inexistente | ❌ Inexistente |
| **Renombrado a Estándar Jellyfin** | ✅ **1-Click (`Título (Año) [tmdbid-ID].ext`)** | ❌ No disponible | ❌ Solo renombrado manual plano |
| **Soporte *Range: bytes* (Seeking)** | ✅ **RFC 7233 Nativo** (<0.1s de latencia) | ✅ Soportado | ✅ Soportado |
| **Auto-Actualización CLI** | ✅ **`faststream --update`** | ❌ Manual | ❌ Manual |

---

## 🗺️ Roadmap de Funcionalidades

- [x] Streaming HTTP RFC 7233 con seeking instantáneo.
- [x] Integración de API TMDB e IMDb con carátulas, fondos y calificaciones.
- [x] Modal interactivo de búsqueda y corrección de metadatos.
- [x] Selector de variantes de idioma de títulos (Español / Inglés / Original).
- [x] Renombrado físico atómico al estándar Jellyfin.
- [x] Selector dinámico de pistas de audio con remuxing al vuelo.
- [x] Selector dinámico de subtítulos incrustados y externos (WebVTT).
- [x] Asignación inteligente de puertos libres (*Auto-Port Hunting*).
- [x] Generador de códigos QR nativo en terminal en Python puro.
- [x] Apagado y liberación de puerto remota desde el navegador web.
- [x] Actualizador automático integrado en CLI (`--update`) y script `update.sh`.
- [ ] Transcodificación por hardware al vuelo (VideoToolbox / NVENC / VAAPI) para códecs antiguos no soportados en navegadores.
- [ ] Modo batch CLI (`faststream --batch-rename /carpeta/`) para renombrado masivo asistido.

---

## 📄 Licencia
MIT License © 2026 Edward Castillo
