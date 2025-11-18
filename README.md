# Создаем README с описанием проекта
cat > README.md << 'EOF'
# My Firewall Setup

Полная конфигурация firewall с:
- Zapret (обход DPI)
- WireGuard (VPN) 
- NFTables (фаервол)
- Systemd сервисы

## Структура:
- `bin/` - основные скрипты
- `etc/` - конфигурации nftables и wireguard
- `scripts/` - скрипты управления
- `systemd/` - сервисы systemd
- `zapret/` - бинарники и настройки Zapret

## Использование:
./scripts/manage-services.sh start|stop|restart
EOF

# Обновляем репозиторий с README
git add README.md
git commit -m "Add README.md"
git push
