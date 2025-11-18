#!/bin/bash

CLIENT_NAME="$1"
CLIENT_DIR="/opt/my-firewall-setup/zapret/clients_db/$CLIENT_NAME"
CONFIG_FILE="$CLIENT_DIR/wg0.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Client $CLIENT_NAME not found!"
    exit 1
fi

# Проверяем установлен ли qrencode
if ! command -v qrencode &> /dev/null; then
    sudo apt update && sudo apt install -y qrencode
fi

echo "QR Code for client: $CLIENT_NAME"
echo "Config:"
cat "$CONFIG_FILE"
echo ""
echo "QR Code:"
qrencode -t ansiutf8 < "$CONFIG_FILE"
