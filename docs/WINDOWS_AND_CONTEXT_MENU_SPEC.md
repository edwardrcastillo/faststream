# ⚡ FastStream: Especificación de Portabilidad para Windows e Integración Universal en Menú Contextual (Windows, macOS, Linux)

> **Documento de Arquitectura y Especificación Técnica**  
> **Estado:** Aprobado / Especificación de Implementación  
> **Módulo:** FastStream CLI (`tools/faststream/` & `scripts/faststream.py`)

---

## 🎯 1. Visión General y Objetivos

El objetivo de esta especificación es doble:
1. **Garantizar compatibilidad nativa al 100% en Windows 10, Windows 11 y Windows Server** sin requerir WSL ni dependencias externas, manteniendo la regla de oro de **Zero Dependencies (Python Estándar Puro)** y tamaño ultra compacto (~124 KB).
2. **Integración con 1 Clic en el Menú Contextual del Sistema Operativo** (Clic derecho sobre cualquier archivo `.mp4`, `.mkv` o carpeta):
   * **Windows:** En el Explorador de Archivos (Windows 10 y Windows 11 Classic/New Menu).
   * **macOS:** En el Finder (Acciones Rápidas / Menú Servicios).
   * **Linux:** En GNOME Files (Nautilus / Pop!_OS), KDE Dolphin, Nemo y Thunar.

---

## 🪟 2. Implicaciones y Adaptaciones Técnicas para Windows

### 2.1. Consola, Páginas de Código UTF-8 y Renderizado QR
* **Diagnóstico:** `cmd.exe` y PowerShell clásico utilizan páginas de código OEM (`CP437` o `CP850`). Intentar renderizar los bloques UTF-8 del código QR (`█`, `▄`, `▀`) o emojis arroja `UnicodeEncodeError`. Además, las secuencias de escape ANSI VT100 para colores no vienen activas por defecto en el subsistema Win32 heredado.
* **Solución Técnica:** Se inyecta una rutina de inicialización Win32 al arrancar el script usando exclusivamente `ctypes` (biblioteca estándar):

```python
if sys.platform == "win32":
    # 1. Configurar salida estándar en UTF-8 puro
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    
    # 2. Habilitar secuencias ANSI (Virtual Terminal Processing) en Windows 10/11
    try:
        import ctypes
        kernel32 = ctypes.windll.kernel32
        h_stdout = kernel32.GetStdHandle(-11)  # STD_OUTPUT_HANDLE = -11
        mode = ctypes.c_ulong()
        if kernel32.GetConsoleMode(h_stdout, ctypes.byref(mode)):
            mode.value |= 0x0004  # ENABLE_VIRTUAL_TERMINAL_PROCESSING
            kernel32.SetConsoleMode(h_stdout, mode)
    except Exception:
        pass
```

### 2.2. Seguridad Anti-Path Traversal y Case-Insensitive en NTFS
* **Diagnóstico:** Los sistemas de archivos NTFS de Windows son **insensibles a mayúsculas y minúsculas** (`C:\Peliculas` es idéntico a `c:\peliculas`). Las comparaciones estrictas de strings (`dest.startswith(base)`) pueden fallar si las letras de unidad o las barras difieren (`/` vs `\`).
* **Solución Técnica:** Función de sanitización agnóstica del sistema operativo:

```python
def is_safe_subpath(base_dir, target_dir):
    base = os.path.realpath(os.path.abspath(base_dir))
    target = os.path.realpath(os.path.abspath(target_dir))
    if sys.platform == "win32":
        base = base.lower()
        target = target.lower()
    return target == base or target.startswith(base + os.sep)
```

### 2.3. Aislamiento de Comandos POSIX
* **Diagnóstico:** Las llamadas a `os.system("stty echo icanon 2>/dev/null")` imprimen error en consolas Windows.
* **Solución Técnica:**
```python
if sys.platform != "win32":
    try:
        os.system("stty echo icanon 2>/dev/null")
    except Exception:
        pass
```

### 2.4. Instalador Automatizado en 1 Línea para PowerShell (`install.ps1`)
Permite a cualquier usuario de Windows instalar y configurar `faststream` en el PATH ejecutando un comando en PowerShell:

```powershell
# Invocación:
iwr -useb https://raw.githubusercontent.com/edwardrcastillo/faststream/main/install.ps1 | iex
```

**Lógica interna de `install.ps1`:**
1. Crea el directorio `%USERPROFILE%\.faststream\`.
2. Descarga `faststream.py`.
3. Genera el ejecutable wrapper `faststream.cmd`:
   ```bat
   @echo off
   python "%~dp0faststream.py" %*
   ```
4. Añade `%USERPROFILE%\.faststream` a la variable de entorno `PATH` del usuario actual en el Registro (`HKCU\Environment`).

---

## 🖱️ 3. Integración en el Menú Contextual (Clic Derecho)

FastStream dispondrá del comando nativo:
```bash
faststream --install-context-menu
faststream --remove-context-menu
```

Este comando detecta el sistema operativo (`win32`, `darwin`, `linux`) e inyecta automáticamente la entrada **"⚡ Transmitir con FastStream"** en el explorador correspondiente.

---

### 3.1. 🪟 Windows (Explorador de Archivos)

#### Claves de Registro (Registro del Usuario `HKEY_CURRENT_USER` sin requerir Administrador):

1. **Para Archivos de Video individuales (`.mp4`, `.mkv`, etc.):**
   * **Ruta de Registro:** `HKCU\Software\Classes\*\shell\FastStream`
   * **Nombre mostrado:** `⚡ Transmitir con FastStream`
   * **Comando:** `cmd.exe /k "faststream \"%1\""` (o `wt.exe faststream \"%1\"` si Windows Terminal está disponible).
   * **Icono:** Icono del sistema o favicon de FastStream.

2. **Para Carpetas y Directorios:**
   * **Ruta de Registro:** `HKCU\Software\Classes\Directory\shell\FastStream`
   * **Ruta de Fondo de Carpeta:** `HKCU\Software\Classes\Directory\Background\shell\FastStream`
   * **Comando:** `cmd.exe /k "faststream \"%V\""`

#### Implementación en Python Puro para Windows (`winreg`):
```python
def register_windows_context_menu():
    import winreg
    cmd_str = f'cmd.exe /k faststream "%1"'
    
    # Registro para archivos
    with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Classes\*\shell\FastStream") as key:
        winreg.SetValueEx(key, "", 0, winreg.REG_SZ, "⚡ Transmitir con FastStream")
        winreg.SetValueEx(key, "Icon", 0, winreg.REG_SZ, "imageres.dll,190") # Icono de reproducción
    with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Classes\*\shell\FastStream\command") as key:
        winreg.SetValueEx(key, "", 0, winreg.REG_SZ, cmd_str)
        
    # Registro para carpetas
    cmd_dir_str = f'cmd.exe /k faststream "%V"'
    with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Classes\Directory\shell\FastStream") as key:
        winreg.SetValueEx(key, "", 0, winreg.REG_SZ, "⚡ Transmitir con FastStream")
        winreg.SetValueEx(key, "Icon", 0, winreg.REG_SZ, "imageres.dll,190")
    with winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Classes\Directory\shell\FastStream\command") as key:
        winreg.SetValueEx(key, "", 0, winreg.REG_SZ, cmd_dir_str)
        
    print("✅ Menú contextual de Windows registrado con éxito.")
```

---

### 3.2. 🍎 macOS (Finder: Acciones Rápidas y Servicios)

En macOS, el clic derecho en Finder se integra a través de los **Servicios de macOS / Acciones Rápidas** (`~/Library/Services/`).

#### Mecanismo Técnico:
Se genera un paquete de servicio Automator `~/Library/Services/⚡ Transmitir con FastStream.workflow` o se ejecuta un script de AppleScript que abre una nueva ventana de Terminal:

```applescript
on run {input, parameters}
    set targetPath to POSIX path of (item 1 of input)
    tell application "Terminal"
        activate
        do script "faststream " & quoted form of targetPath
    end tell
end run
```

#### Instalación Automática en macOS desde CLI:
FastStream genera un script ligero en `~/Library/Services/` que aparece inmediatamente en:
* **Clic Derecho -> Acciones Rápidas -> ⚡ Transmitir con FastStream**
* **Clic Derecho -> Servicios -> ⚡ Transmitir con FastStream**

---

### 3.3. 🐧 Linux (GNOME / Nautilus / Pop!_OS / KDE Dolphin / XFCE Thunar)

En Linux existen dos métodos nativos probados:

#### A. GNOME Files / Nautilus (Pop!_OS, Ubuntu, Fedora):
Nautilus tiene soporte nativo para scripts de usuario en `~/.local/share/nautilus/scripts/`:
1. FastStream escribe el script ejecutable:
   `~/.local/share/nautilus/scripts/⚡ Transmitir con FastStream`
2. **Contenido del script:**
   ```bash
   #!/usr/bin/env bash
   # Abre terminal con faststream apuntando al elemento seleccionado
   gnome-terminal -- bash -c "faststream \"$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS\"; exec bash" 2>/dev/null || \
   x-terminal-emulator -e "faststream \"$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS\"" 2>/dev/null || \
   faststream "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
   ```
3. **Resultado:** Clic derecho sobre cualquier video o carpeta en Nautilus -> **Scripts** -> **⚡ Transmitir con FastStream**.

#### B. KDE Dolphin (KDE Plasma):
Dolphin utiliza archivos de menú de servicio `.desktop` en `~/.local/share/kservices5/ServiceMenus/faststream.desktop`:
```ini
[Desktop Entry]
Type=Service
ServiceTypes=KonqPopupMenu/Plugin
MimeType=video/*;inode/directory;
Actions=faststream;

[Desktop Action faststream]
Name=⚡ Transmitir con FastStream
Icon=video-x-generic
Exec=konsole -e faststream %f
```

---

## 🗺️ 4. Plan de Ejecución

| Fase | Tarea | Plataformas |
| :---: | :--- | :---: |
| **Fase 1** | Incorporar inicialización Win32 (`ctypes`), UTF-8 en stdout y función `is_safe_subpath` en `faststream.py`. | Windows |
| **Fase 2** | Crear `install.ps1` y `faststream.cmd` para distribución en Windows vía PowerShell. | Windows |
| **Fase 3** | Implementar los flags CLI `faststream --install-context-menu` y `--remove-context-menu`. | Windows, macOS, Linux |
| **Fase 4** | Probar la apertura directa de terminal con código QR al hacer clic derecho en archivos `.mp4` y carpetas. | Windows 11, macOS, Pop!_OS |

---
*FastStream: Cero dependencias, máxima velocidad y experiencia nativa en todos los sistemas operativos.*
