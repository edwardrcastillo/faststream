#!/usr/bin/env bash
# ⚡ FastStream 1-Line Updater
# Usage: curl -sSL https://raw.githubusercontent.com/edwardrcastillo/faststream/main/update.sh | bash

set -e

SOURCE_URL="https://raw.githubusercontent.com/edwardrcastillo/faststream/main/faststream"

echo "=================================================================="
echo "⚡ FastStream - Actualizador de Versión"
echo "=================================================================="

if command -v curl >/dev/null 2>&1; then
    DOWNLOAD_CMD="curl -fsSL"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget -qO-"
else
    echo "❌ Error: Se requiere curl o wget."
    exit 1
fi

TMP_FILE=$(mktemp /tmp/faststream_update.XXXXXX)
$DOWNLOAD_CMD "$SOURCE_URL" > "$TMP_FILE"
chmod +x "$TMP_FILE"

INSTALLED_LOCATIONS=()

# 1. Detectar si ya existe en PATH
EXISTING_PATH=$(command -v faststream 2>/dev/null || true)
if [ -n "$EXISTING_PATH" ] && [ -w "$EXISTING_PATH" ]; then
    cp "$TMP_FILE" "$EXISTING_PATH"
    chmod +x "$EXISTING_PATH"
    INSTALLED_LOCATIONS+=("$EXISTING_PATH")
elif [ -n "$EXISTING_PATH" ]; then
    echo "🔒 Actualizando $EXISTING_PATH (requiere permisos de administrador)..."
    sudo cp "$TMP_FILE" "$EXISTING_PATH"
    sudo chmod +x "$EXISTING_PATH"
    INSTALLED_LOCATIONS+=("$EXISTING_PATH")
fi

# 2. Asegurar instalación en ~/.local/bin
USER_LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$USER_LOCAL_BIN"
cp "$TMP_FILE" "$USER_LOCAL_BIN/faststream"
chmod +x "$USER_LOCAL_BIN/faststream"
if [[ " ${INSTALLED_LOCATIONS[*]} " != *" $USER_LOCAL_BIN/faststream "* ]]; then
    INSTALLED_LOCATIONS+=("$USER_LOCAL_BIN/faststream")
fi

# 3. Si /usr/local/bin es accesible, actualizar también
SYS_LOCAL_BIN="/usr/local/bin"
if [ -d "$SYS_LOCAL_BIN" ] && [ -w "$SYS_LOCAL_BIN" ]; then
    cp "$TMP_FILE" "$SYS_LOCAL_BIN/faststream"
    chmod +x "$SYS_LOCAL_BIN/faststream"
    if [[ " ${INSTALLED_LOCATIONS[*]} " != *" $SYS_LOCAL_BIN/faststream "* ]]; then
        INSTALLED_LOCATIONS+=("$SYS_LOCAL_BIN/faststream")
    fi
fi

rm -f "$TMP_FILE"

INSTALLED_VER=$(grep -m 1 "FASTSTREAM v" "$USER_LOCAL_BIN/faststream" | sed -E 's/.*(FASTSTREAM v[0-9.]+).*/\1/' || echo "FastStream v2.1.0")

echo "=================================================================="
echo "🎉 ¡$INSTALLED_VER actualizado con éxito!"
for loc in "${INSTALLED_LOCATIONS[@]}"; do
    echo "   📍 $loc"
done
echo "=================================================================="
echo "💡 Uso rápido:"
echo "   faststream pelicula.mp4"
echo "   faststream /ruta/a/carpeta/series/"
echo "   faststream --update"
echo "=================================================================="
