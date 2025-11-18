#!/bin/bash

CLIENT_NAME="$1"
CLIENT_DIR="/opt/my-firewall-setup/zapret/clients_db/$CLIENT_NAME"
SERVER_PUBLIC_KEY="TZp3B/+lnP9SJGc1YpqRQPHzGcmoudyqnl5rFEmfWXw="
SERVER_ENDPOINT="$(curl -s ifconfig.me):51820"

# Создаем директорию клиента
mkdir -p "$CLIENT_DIR"

# Генерируем ключи для клиента
wg genkey | tee "$CLIENT_DIR/privatekey" | wg pubkey > "$CLIENT_DIR/publickey"
CLIENT_PRIVATE_KEY=$(cat "$CLIENT_DIR/privatekey")
CLIENT_PUBLIC_KEY=$(cat "$CLIENT_DIR/publickey")

# Функция для получения следующего свободного IP
get_next_ip() {
    # Получаем список всех используемых IP из WireGuard
    USED_IPS=$(sudo wg show wg0 | grep "allowed ips" | awk '{print $3}' | cut -d'/' -f1)
    
    # Перебираем IP от 2 до 254
    for i in {2..254}; do
        IP="10.0.0.$i"
        if ! echo "$USED_IPS" | grep -q "$IP"; then
            echo "$IP"
            return
        fi
    done
    echo "10.0.0.255"  # fallback, но этого не должно случиться
}

CLIENT_IP=$(get_next_ip)

# Создаем конфиг клиента
tee "$CLIENT_DIR/wg0.conf" > /dev/null << CLIENT_CONFIG
[Interface]
PrivateKey = $CLIENT_PRIVATE_KEY
Address = $CLIENT_IP/32
DNS = 8.8.8.8

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $SERVER_ENDPOINT
AllowedIPs = 0.0.0.0/0
CLIENT_CONFIG

# Добавляем клиента в сервер
sudo wg set wg0 peer "$CLIENT_PUBLIC_KEY" allowed-ips "$CLIENT_IP/32"

# Сохраняем информацию о клиенте
echo "Client: $CLIENT_NAME" > "$CLIENT_DIR/info.txt"
echo "IP: $CLIENT_IP" >> "$CLIENT_DIR/info.txt"
echo "Public Key: $CLIENT_PUBLIC_KEY" >> "$CLIENT_DIR/info.txt"
echo "Added: $(date)" >> "$CLIENT_DIR/info.txt"

echo "Client $CLIENT_NAME added successfully!"
echo "IP: $CLIENT_IP"
echo "Config file: $CLIENT_DIR/wg0.conf"
