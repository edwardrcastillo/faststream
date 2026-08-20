#!/usr/bin/env bash
# ⚡ FastStream 1-Line Installer
# Usage: curl -sSL https://raw.githubusercontent.com/edwardrcastillo/faststream/main/install.sh | bash

set -e

INSTALL_DIR="/usr/local/bin"
TARGET="$INSTALL_DIR/faststream"
SOURCE_URL="https://raw.githubusercontent.com/edwardrcastillo/faststream/main/faststream"

echo "⚡ Instalando FastStream..."

if command -v curl >/dev/null 2>&1; then
    DOWNLOAD_CMD="curl -fsSL"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget -qO-"
else
    echo "❌ Error: Se requiere curl o wget."
    exit 1
fi

if [ -w "$INSTALL_DIR" ]; then
    $DOWNLOAD_CMD "$SOURCE_URL" > "$TARGET"
    chmod +x "$TARGET"
else
    echo "🔒 Solicitando permisos para instalar en $INSTALL_DIR..."
    $DOWNLOAD_CMD "$SOURCE_URL" | sudo tee "$TARGET" > /dev/null
    sudo chmod +x "$TARGET"
fi

echo ""
echo "🎉 ¡FastStream instalado con éxito en $TARGET!"
echo "💡 Uso rápido:"
echo "   faststream pelicula.mp4"
echo "   faststream /ruta/a/carpeta/series/"
