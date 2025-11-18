#!/bin/bash

CLIENT_NAME="$1"
CLIENT_DIR="/opt/my-firewall-setup/zapret/clients_db/$CLIENT_NAME"

if [ ! -d "$CLIENT_DIR" ]; then
    echo "Client $CLIENT_NAME not found!"
    exit 1
fi

# Получаем публичный ключ клиента
CLIENT_PUBLIC_KEY=$(cat "$CLIENT_DIR/publickey" 2>/dev/null)

if [ -n "$CLIENT_PUBLIC_KEY" ]; then
    # Удаляем клиента из сервера
    sudo wg set wg0 peer "$CLIENT_PUBLIC_KEY" remove
    echo "Removed client $CLIENT_NAME from server"
fi

# Удаляем директорию клиента
rm -rf "$CLIENT_DIR"
echo "Removed client directory: $CLIENT_DIR"
